local modules = {}
function module(rsc, path) -- load a LUA resource file as module
  if path == nil then -- shortcut for vrp, can omit the resource parameter
    path = rsc
    rsc = "vrp"
  end

  local key = rsc..path

  if modules[key] then -- cached module
    return table.unpack(modules[key])
  else
    local f,err = load(LoadResourceFile(rsc, path..".lua"))
    if f then
      local ar = {pcall(f)}
      if ar[1] then
        table.remove(ar,1)
        modules[key] = ar
        return table.unpack(ar)
      else
        modules[key] = nil
        print("[vRP] error loading module "..rsc.."/"..path..":"..ar[2])
      end
    else
      print("[vRP] error parsing module "..rsc.."/"..path..":"..err)
    end
  end
end

function ordinal_numbers(n)
  local ordinal, digit = {"st", "nd", "rd"}, string.sub(n, -1)
  if tonumber(digit) > 0 and tonumber(digit) <= 3 and string.sub(n,-2) ~= "11" and string.sub(n,-2) ~= "12" and string.sub(n,-2) ~= "13" then
    return n .. ordinal[tonumber(digit)]
  else
    return n .. "th"
  end
end

function distanceToTime(meters, simple)
    local seconds = math.floor((meters / 21) + 0.5)
    local minutes = math.floor((seconds / 60) + 0.5)
    if simple then
        if minutes > 0 then
            return ("%.01i minute%s"):format(minutes, (minutes == 1 and "" or "s"))
        end
        return ("%.01i second%s"):format(seconds, (seconds == 1 and "" or "s"))
    end
    return ("%.02im %.02is"):format(minutes, seconds % 60)
end

-- generate a task metatable (helper to return delayed values with timeout)
--- dparams: default params in case of timeout or empty cbr()
--- timeout: milliseconds, default 5000
function Task(callback, dparams, timeout)
  if timeout == nil then timeout = 5000 end

  local r = {}
  r.done = false

  local finish = function(params)
    if not r.done then
      if params == nil then params = dparams or {} end
      r.done = true
      if callback then callback(table.unpack(params)) end
    end
  end

  setmetatable(r, {__call = function(t,params) finish(params) end })
  SetTimeout(timeout, function() finish(dparams) end)

  return r
end

function parseInt(v)
    if type(v) == 'string' and v:len() > 12 then
        print("[vRP] tried to parse >12 digit int, failsafe returning 0 instead")
        return 0
    end
    --  return cast(int,tonumber(v))
    local n = tonumber(v)
    if n == nil then
        return 0
    else
        return math.floor(n)
    end
end

function parseDouble(v)
--  return cast(double,tonumber(v))
  if type(v) == 'string' and v:len() > 12 then
    print("[vRP] tried to parse >12 digit double, failsafe returning 0 instead")
    return 0
  end
  local n = tonumber(v)
  if n == nil then n = 0 end
  return n
end

function parseFloat(v)
  return parseDouble(v)
end

-- will remove chars not allowed/disabled by strchars
-- if allow_policy is true, will allow all strchars, if false, will allow everything except the strchars
local sanitize_tmp = {}
function sanitizeString(str, strchars, allow_policy)
  local r = ""

  -- get/prepare index table
  local chars = sanitize_tmp[strchars]
  if chars == nil then
    chars = {}
    local size = string.len(strchars)
    for i=1,size do
      local char = string.sub(strchars,i,i)
      chars[char] = true
    end

    sanitize_tmp[strchars] = chars
  end

  -- sanitize
  size = string.len(str)
  for i=1,size do
    local char = string.sub(str,i,i)
    if (allow_policy and chars[char]) or (not allow_policy and not chars[char]) then
      r = r..char
    end
  end

  return r
end

function splitString(str, sep)
  if sep == nil then sep = "%s" end

  local t={}
  local i=1

  for str in string.gmatch(str, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end

  return t
end

function joinStrings(list, sep)
  if sep == nil then sep = "" end

  local str = ""
  local count = 0
  local size = #list
  for k,v in pairs(list) do
    count = count+1
    str = str..v
    if count < size then str = str..sep end
  end

  return str
end

function CLAMP(value, data)
    data = data or {}
    if value > -2000000000 and value < 2000000000 then
        return value
    end

    data.clamped_value = tostring(value)
    print("[vRP] CLAMPED >2T VALUE. URGENT ISSUE TO BE ADDRESSED")
    TriggerEvent("omni:logger", "VALUE CLAMP OMNIURGENT", json.encode(data))
    if value > -2000000000 then
        return 2000000000
    end
    return -2000000000
end

function SecondsToClock(seconds)
    local seconds = math.abs(tonumber(seconds))

    if seconds <= 0 then
        return "00h 00m";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return ("%sh %sm"):format(hours, mins)
    end
end

-- Returns format based on duration
-- 6d 21h (if over one day)
-- 06h 21m (if over one hour)
-- 06m 21s (if below an hour)
function SecondsToDuration(s)
    local seconds = math.abs(tonumber(s))
    if s <= 0 then
        return "00m 00s";
    else
        days = string.format("%01.f", math.floor(s / (3600 * 24))) s = s - (3600 * 24 * days)
        hours = string.format("%02.f", math.floor(s / 3600)); s = s - (3600 * hours)
        mins = string.format("%02.f", math.floor(s / 60)); s = s - (60 * mins)
        secs = string.format("%02.f", math.floor(s));
        if tonumber(days) > 0 then return ("%sd %sh"):format(days, hours) end
        if tonumber(hours) > 0 then return ("%sh %sm"):format(hours, mins) end
        return ("%sm %ss"):format(mins, secs)
    end
end

function ReadableNumber(num, places, full)
    num = tonumber(num)
    if not num then return 0 end
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    local isNegative = num < 0
    num = math.abs(num)
    if num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. (full and " trillion" or "T") -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. (full and " billion" or "B") -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. (full and " million" or "M") -- million
    elseif num >= 1000 and not full then
        ret = placeValue:format(num / 1000) .. "k" -- thousand
    elseif num >= 1 then
        ret = placeValue:format(num) -- hundreds
    else
        ret = placeValue:format(num)
    end
    return (isNegative and "-" or "") .. ret
end

function ReadableMoney(num, places, full, noPrefix)
    num = tonumber(num)
    if not num then return 0 end
    local ret
    local placeValue = ("%%.%df"):format(places or 2)
    local isNegative = num < 0
    num = num / --[[ECONOMY]] 1 --[[MODIFIER]]
    num = math.abs(num)
    if num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. (full and " trillion" or "T") -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. (full and " billion" or "B") -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. (full and " million" or "M") -- million
    elseif num >= 1000 and not full then
        ret = placeValue:format(num / 1000) .. "k" -- thousand
    elseif num >= 1 then
        ret = placeValue:format(num) -- hundreds
    else
        if noPrefix then return placeValue:format(num) end
        return math.ceil(num * 100) .. "¢"
    end
    return (isNegative and "-" or "") .. (noPrefix and "" or "$") .. ret
end

local function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

local function round(val, decimal)
    if (decimal) then
        return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
    else
        return math.floor(val+0.5)
    end
end

function formatNumber(amount, decimal, prefix, neg_prefix)
    local str_amount,  formatted, famount, remain

    decimal = decimal or 2  -- default 2 decimal places
    neg_prefix = neg_prefix or "-" -- default negative sign

    famount = math.abs(round(amount,decimal))
    famount = math.floor(famount)

    remain = round(math.abs(amount) - famount, decimal)

    -- comma to separate the thousands
    formatted = comma_value(famount)

    -- attach the decimal portion
    if (decimal > 0) then
        remain = string.sub(tostring(remain),3)
        formatted = formatted .. "." .. remain ..
        string.rep("0", decimal - string.len(remain))
    end

    -- attach prefix string e.g '$'
    formatted = (prefix or "") .. formatted

    -- if value is negative then format accordingly
    if (amount<0) then
        if (neg_prefix=="()") then
            formatted = "("..formatted ..")"
        else
            formatted = neg_prefix .. formatted
        end
    end

    return formatted
end
function formatMoney(amount, decimal, prefix, neg_prefix)
    return formatNumber(amount / --[[ECONOMY]] 1 --[[MODIFIER]], decimal, prefix, neg_prefix)
end

-- stolen from nex (thanks bud)
table.has = function(tab, val)
    for k,v in pairs(tab) do
        if v == val then
            return true
        end
    end
    return false
end

function ConvertInputToNumber(input, max)
    local output = 0
    local modifiers = {c = 0.01, C = 0.01, k = 10^3, K = 10^3, m = 10^6, M = 10^6, b = 10^9, B = 10^9, t = 10^12, T = 10^12}
    input = input:gsub(",", ".")
    input = input:gsub(" ", "")
    local currentNumber = nil
    local currentNumberString = ""
    for i = 1, input:len(), 1 do
        local char = input:sub(i, i)
        if modifiers[char] then
            if not currentNumber then
                currentNumber = tonumber(currentNumberString) or 0
            end
            currentNumberString = ""
            currentNumber = currentNumber * modifiers[char]
        else
            if currentNumber then
                output = output + currentNumber
                currentNumber = nil
            end
            currentNumberString = currentNumberString .. char
        end
    end
    if currentNumber then
        output = output + currentNumber
    elseif currentNumberString ~= "" then
        output = output + tonumber(currentNumberString) or 0
    end
    if max then output = math.min(output, max) end
    return output
end

function ParseCustomFormatString(input, value)
    if (type(value) == "number") then
        input = input:gsub("{i}", ReadableNumber(value))
        input = input:gsub("{m}", ReadableMoney(value))
        input = input:gsub("{s}", value)
        return input
    end
    input = input:gsub("{i}", value)
    input = input:gsub("{m}", value)
    input = input:gsub("{s}", value)
    return input
end

if IsDuplicityVersion() then
    CreateThread(function()
        math.randomseed(os.time())
        for i = 0, math.random(20, 200) do math.random() end
        while true do
            Wait(math.random(100))
            for i = 0, math.random(2, 10) do math.random() end
        end
    end)
end

function T(t)
    return setmetatable(t, {__index = table})
end

-- Returns a new table with each value formatted based on the function passed.
function table.map(arr, func)
    local new = T{}
    for key, value in next, arr do
        new[key] = func(value, key)
    end
    return new
end

-- Returns a new table with only values that passed the function check.
function table.filter(arr, func)
    local new = T{}
    for key, value in next, arr do
        if func(value, key) then
            new[#new + 1] = value
        end
    end
    return new
end

-- Reduces the table into a single value.
function table.reduce(arr, func, initial)
    local acc = initial or 0
    for key, value in next, arr do
        acc = func(acc, value, key)
    end
    return acc
end

-- Checks if every value in the table passes the function check.
function table.every(arr, func)
    for key, value in next, arr do
        if not func(value, key) then
            return false
        end
    end
    return true
end

-- Checks if any value in the table passes the function check.
function table.some(arr, func)
    for key, value in next, arr do
        if func(value, key) then
            return true
        end
    end
    return false
end
table.any = table.some

-- Checks if a value is in the table.
function table.includes(arr, value)
    for key, v in next, arr do
        if v == value then
            return true
        end
    end
    return false
end

-- Finds the first index of a value in the table.
function table.indexOf(arr, value)
    for key, v in next, arr do
        if v == value then
            return key
        end
    end
    return -1
end

-- Finds the last index of a value in the table.
function table.lastIndexOf(arr, value)
    local index = -1
    for key, v in next, arr do
        if v == value then
            index = key
        end
    end
    return index
end

-- Returns the value if it is in the table, otherwise returns nil.
function table.find(arr, func)
    for key, value in next, arr do
        if func(value, key) then
            return value
        end
    end
    return nil
end

-- Runs the function on every value in the table.
function table.forEach(arr, func)
    for key, value in next, arr do
        func(value, key, arr)
    end
end

-- Returns a grouped list of values based on the function passed.
function table.group(arr, func)
    local new = T{}
    for key, value in next, arr do
        local group = func(value, key, arr)
        if not new[group] then
            new[group] = {}
        end
        new[group][#new[group] + 1] = value
    end
    return new
end