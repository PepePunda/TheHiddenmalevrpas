
-- define aptitude system (aka. education, skill system)
-- define skills system (aka. education, skill system)

local cfg = module("cfg/Skills")
local lang = vRP.lang

local exp_step = 5

local gskills = {}

function vRP.defSkillGroup(group, title)
  gskills[group] = {_title = title}
end

-- max_exp: -1 => infinite
function vRP.defSkill(group, skill, title, init_exp, max_exp)
  local vgroup = gskills[group]
  if vgroup ~= nil then
    vgroup[skill] = {title,init_exp,max_exp}
  end
end

function vRP.getSkillDefinition(group, skill)
  local vgroup = gskills[group]
  if vgroup ~= nil and skill ~= "_title" then
    return vgroup[skill]
  else
    return nil
  end
end

function vRP.getSkillGroupTitle(group)
  if gskills[group] ~= nil then
    return gskills[group]._title
  else
    return ""
  end
end

-- return user skills table
function vRP.getUserSkills(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data ~= nil then
    if data.gskills == nil then
      data.gskills = {}
    end

    -- init missing skills
    for k,v in pairs(gskills) do
      if data.gskills[k] == nil then -- init group
        data.gskills[k] = {}
      end

      local group = data.gskills[k]
      for l,w in pairs(v) do
        if l ~= "_title" and group[l] == nil then -- init skill exp
          group[l] = w[2] -- init exp
        end
      end
    end

    return data.gskills
  else
    return nil
  end
end

function vRP.varyExp(user_id, group, skill, amount)
  local def = vRP.getSkillDefinition(group, skill)
  local uskills = vRP.getUserSkills(user_id)
  if def ~= nil and uskills ~= nil then
    local exp = uskills[group][skill]
    local level = math.floor(vRP.expToLevel(exp))

    exp = exp + amount
    if exp < 0 then exp = 0 
    elseif def[3] >= 0 and exp > def[3] then exp = def[3] end

    uskills[group][skill] = exp

    local player = vRP.getUserSource(user_id)
    if player ~= nil then
      local group_title = vRP.getSkillGroupTitle(group)
      local skill_title = def[1]

      if amount < 0 then
        vRPclient.notify(player,{lang.skill.lose_exp({group_title,skill_title,-1*amount})})
      elseif amount > 0 then
        vRPclient.notify(player,{lang.skill.earn_exp({group_title,skill_title,amount})})
      end
      local new_level = math.floor(vRP.expToLevel(exp))
      local diff = new_level - level
      if diff < 0 then
        vRPclient.notify(player,{lang.skill.level_down({group_title,skill_title,new_level})})
      elseif diff > 0 then
        vRPclient.notify(player,{lang.skill.level_up({group_title,skill_title,new_level})})
      end
    end
  end
end

function vRP.levelUp(user_id, group, skill)
  local exp = vRP.getExp(user_id, group, skill)
  local next_level = math.floor(vRP.expToLevel(exp)) + 1
  local next_exp = vRP.levelToExp(next_level)
  local add_exp = next_exp - exp
  vRP.varyExp(user_id, group, skill, add_exp)
end

function vRP.levelDown(user_id, group, skill)
  local exp = vRP.getExp(user_id, group, skill)
  local prev_level = math.floor(vRP.expToLevel(exp)) - 1
  local prev_exp = vRP.levelToExp(prev_level)
  local add_exp = prev_exp - exp
  vRP.varyExp(user_id, group, skill, add_exp)
end

function vRP.getExp(user_id, group, skill)
  local uskills = vRP.getUserSkills(user_id)
  if uskills ~= nil then
    local vgroup = uskills[group]
    if vgroup ~= nil then
      return vgroup[skill] or 0
    end
  end

  return 0
end

function vRP.setExp(user_id, group, skill, amount)
  local exp = vRP.getExp(user_id, group, skill)
  vRP.varyExp(user_id, group, skill, amount - exp)
end

function vRP.expToLevel(exp)
  return (math.sqrt(1 + 8 * exp / exp_step) - 1) / 2
end

function vRP.levelToExp(lvl)
  return math.floor((exp_step * lvl * (lvl + 1)) / 2)
end

-- CONFIG

-- load config skills
for k, v in pairs(cfg.gskills) do
  vRP.defSkillGroup(k, v._title or "")
  for l, w in pairs(v) do
    if l ~= "_title" then
      vRP.defSkill(k, l, w[1], w[2], w[3])
    end
  end
end

-- MENU

local player_skills = {}

local function ch_skill(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if player_skills[player] then
      player_skills[player] = nil
      vRPclient.removeDiv(player, {"user_skills"})
    else
      local content = ""
      local uskills = vRP.getUserSkills(user_id)
      for k, v in pairs(uskills) do
        content = content .. lang.skill.display.group({vRP.getSkillGroupTitle(k)}) .. "<br />"
        for l, w in pairs(v) do
          local def = vRP.getSkillDefinition(k, l)
          if def then
            local exp = uskills[k][l]
            local flvl = vRP.expToLevel(exp)
            local lvl = math.floor(flvl)
            local percent = math.floor((flvl - lvl) * 100)
            content = content .. "<div class=\"dprogressbar\" data-value=\"" .. (percent / 100) .. "\" data-color=\"rgba(0,125,255,0.7)\" data-bgcolor=\"rgba(0,125,255,0.3)\">" .. lang.skill.display.skill({def[1], exp, lvl, percent}) .. "</div>"
          end
        end
      end

      player_skills[player] = true

      local css = [[
.div_user_skills{
  margin: auto;
  padding: 8px;
  width: 500px;
  margin-top: 80px;
  background: black;
  color: white;
  font-weight: bold;
}

.div_user_skills .dprogressbar{
  width: 100%;
  height: 20px;
}
      ]]

      vRPclient.setDiv(player, {"user_skills", css, content})
    end
  end
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
    choices[lang.skill.title()] = {ch_skill, lang.skill.description()}

    add(choices)
  end
end)

-- update player display
function vRP.updateLevelDisplay(player)
  local user_id = vRP.getUserId(player)
  if user_id then
    local exp = vRP.getExp(user_id, "physical", "strength")
    local level = math.floor(vRP.expToLevel(exp))
    local next_exp = vRP.nextLevelExp(level)
    vRPclient.setLevelDisplay(player, {"Strength", level, exp, next_exp})
  end
end



