local lang = vRP.lang
local cfg = module("cfg/inventory")

vRP.items = {}

-- Define an inventory item
function vRP.defInventoryItem(idname, name, description, choices, weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name, description=description, choices=choices, weight=weight}
  vRP.items[idname] = item

  item.ch_give = function(player, choice)
  end

  item.ch_trash = function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      vRP.prompt(player, lang.inventory.trash.prompt({vRP.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
        local amount = parseInt(amount)
        if vRP.tryGetInventoryItem(user_id, idname, amount, false) then
          vRPclient.notify(player, {lang.inventory.trash.done({vRP.getItemName(idname), amount})})
          vRPclient.playAnim(player, {true, {{"pickup_object", "pickup_low", 1}}, false})
        else
          vRPclient.notify(player, {lang.common.invalid_value()})
        end
      end)
    end
  end
end

function ch_give(idname, player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {10}, function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
          vRP.prompt(player, lang.inventory.give.prompt({vRP.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
            local amount = parseInt(amount)
            local new_weight = vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(idname) * amount
            if new_weight <= vRP.getInventoryMaxWeight(nuser_id) then
              if vRP.tryGetInventoryItem(user_id, idname, amount, true) then
                vRP.giveInventoryItem(nuser_id, idname, amount, true)
                vRPclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                vRPclient.playAnim(nplayer, {true, {{"mp_common", "givetake2_a", 1}}, false})
              else
                vRPclient.notify(player, {lang.common.invalid_value()})
              end
            else
              vRPclient.notify(player, {lang.inventory.full()})
            end
          end)
        else
          vRPclient.notify(player, {lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player, {lang.common.no_player_near()})
      end
    end)
  end
end

function ch_trash(idname, player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player, lang.inventory.trash.prompt({vRP.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
      local amount = parseInt(amount)
      if vRP.tryGetInventoryItem(user_id, idname, amount, false) then
        vRPclient.notify(player, {lang.inventory.trash.done({vRP.getItemName(idname), amount})})
        vRPclient.playAnim(player, {true, {{"pickup_object", "pickup_low", 1}}, false})
      else
        vRPclient.notify(player, {lang.common.invalid_value()})
      end
    end)
  end
end

function vRP.computeItemName(item, args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function vRP.computeItemDescription(item, args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function vRP.computeItemChoices(item, args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function vRP.computeItemWeight(item, args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end

function vRP.parseItem(idname)
  return splitString(idname, "|")
end

function vRP.getItemDefinition(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then
    return vRP.computeItemName(item, args), vRP.computeItemDescription(item, args), vRP.computeItemWeight(item, args)
  end
  return nil, nil, nil
end

function vRP.getItemName(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemName(item, args) end
  return args[1]
end

function vRP.getItemDescription(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemDescription(item, args) end
  return ""
end

function vRP.getItemChoices(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  local choices = {}
  if item ~= nil then
    local cchoices = vRP.computeItemChoices(item, args)
    if cchoices then
      for k, v in pairs(cchoices) do
        choices[k] = v
      end
    end
    choices[lang.inventory.give.title()] = {function(player, choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
  end
  return choices
end

function vRP.getItemWeight(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemWeight(item, args) end
  return 0
end

function vRP.computeItemsWeight(items)
  local weight = 0
  for k, v in pairs(items) do
    local iweight = vRP.getItemWeight(k)
    weight = weight + iweight * v.amount
  end
  return weight
end

function vRP.giveInventoryItem(user_id, idname, amount, notify)
  if notify == nil then notify = true end

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then
      entry.amount = entry.amount + amount
    else
      data.inventory[idname] = {amount = amount}
    end
    if notify then
      local player = vRP.getUserSource(user_id)
      if player ~= nil then
        vRPclient.notify(player, {lang.inventory.give.received({vRP.getItemName(idname), amount})})
      end
    end
  end
end

-- Function to handle vehicle trunk inventory
function vRP.giveInventoryItemToVehicle(user_id, vehicle_id, idname, amount, notify)
  if notify == nil then notify = true end

  local vehicle_inventory = vRP.vehicleInventory[vehicle_id] or {}
  vehicle_inventory[idname] = (vehicle_inventory[idname] or 0) + amount
  vRP.vehicleInventory[vehicle_id] = vehicle_inventory

  if notify then
    local player = vRP.getUserSource(user_id)
    if player ~= nil then
      vRPclient.notify(player, {"Added "..amount.." "..idname.." to the trunk."})
    end
  end
end

function vRP.tryGetInventoryItem(user_id, idname, amount, notify)
  if notify == nil then notify = true end

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then
      entry.amount = entry.amount - amount
      if entry.amount <= 0 then
        data.inventory[idname] = nil
      end
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          vRPclient.notify(player, {lang.inventory.give.given({vRP.getItemName(idname), amount})})
        end
      end
      return true
    else
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          vRPclient.notify(player, {lang.inventory.missing({vRP.getItemName(idname), amount - entry_amount})})
        end
      end
    end
  end
  return false
end

function vRP.getInventoryItemAmount(user_id, idname)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end
  return 0
end

function vRP.getInventoryWeight(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    return vRP.computeItemsWeight(data.inventory)
  end
  return 0
end

function vRP.getInventoryMaxWeight(user_id)
  local base_weight = 50 -- base inventory weight
  local strength_level = math.floor(vRP.expToLevel(vRP.getExp(user_id, "physical", "strength")))
  local max_weight = base_weight + (strength_level * cfg.inventory_weight_per_strength)
  return max_weight
end

function vRP.clearInventory(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end

function vRP.openInventory(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data then
      local menudata = {name=lang.inventory.title(), css={top="75px", header_color="rgba(0,125,255,0.75)"}}
      local weight = vRP.getInventoryWeight(user_id)
      local max_weight = vRP.getInventoryMaxWeight(user_id)
      local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
      menudata["<div class=\"dprogressbar\" data-value=\""..string.format("%.0f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.0f",weight), max_weight})}
      local kitems = {}

      local choose = function(player, choice)
        if string.sub(choice, 1, 1) ~= "@" then
          local choices = vRP.getItemChoices(kitems[choice])
          local submenudata = {name=choice, css={top="75px", header_color="rgba(0,125,255,0.75)"}}

          for k, v in pairs(choices) do
            submenudata[k] = v
          end

          submenudata.onclose = function()
            vRP.openInventory(source)
          end

          vRP.openMenu(source, submenudata)
        end
      end

      for k, v in pairs(data.inventory) do 
        local name, description, weight = vRP.getItemDefinition(k)
        if name ~= nil then
          kitems[name] = k
          menudata[name] = {choose, lang.inventory.iteminfo({v.amount, description, string.format("%.0f", weight)})}
        end
      end

      vRP.openMenu(source, menudata)
    end
  end
end

AddEventHandler("vRP:playerJoin", function(user_id, source, name, last_login)
  local data = vRP.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)

local choices = {}
choices[lang.inventory.title()] = {function(player, choice) vRP.openInventory(player) end, lang.inventory.description()}

vRP.registerMenuBuilder("main", function(add, data)
  add(choices)
end)

local chests = {}

local function build_itemlist_menu(name, items, cb)
  local menu = {name=name, css={top="75px", header_color="rgba(0,255,125,0.75)"}}
  local kitems = {}

  local choose = function(player, choice)
    local idname = kitems[choice]
    if idname then
      cb(idname)
    end
  end

  -- Check if items table is empty
  if next(items) == nil then
     menu[lang.common.empty()] = {function()end} -- Use a common language entry for empty
  else
      for k, v in pairs(items) do
        local name, description, weight = vRP.getItemDefinition(k)
        if name ~= nil then
          kitems[name] = k
          -- Format weight nicely, handle potential nil weight from getItemDefinition
          local weight_str = "?.??"
          if weight then weight_str = string.format("%.2f", weight) end
          menu[name] = {choose, lang.inventory.iteminfo({v.amount, description, weight_str})}
        end
      end
  end


  return menu
end

function vRP.openChest(source, name, max_weight, cb_close, cb_in, cb_out, title)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data.inventory ~= nil then
      if chests[name] and chests[name].user_id ~= user_id then
         vRPclient.notify(source, {lang.inventory.chest.already_opened()})
         return
      end

      chests[name] = {user_id = user_id, max_weight = max_weight, items = {}} -- Mark chest as opened, initialize items table

      local menu_title = title or lang.inventory.chest.title()
      local close_count = 0 -- Keep track of open submenus

      -- Define the main menu structure *outside* the async call but *inside* openChest scope
      local main_chest_menu = {
          name=menu_title,
          css={top="75px", header_color="rgba(0,255,125,0.75)"}
      }

      -- Fetch initial chest data
      vRP.getSData("chest:"..name, function(cdata)
          -- Double-check if the chest is still supposed to be open for this user
          if not chests[name] or chests[name].user_id ~= user_id then
              print("[vRP Inventory] Chest state changed during getSData for: "..name)
              return
          end

          chests[name].items = json.decode(cdata) or {} -- Load items into runtime state

          -- --- Callbacks Definition ---
          -- (Define cb_take, cb_put, cb_trash - ensure they only modify chests[name].items)

          -- Callback for Take action
          local cb_take = function(idname)
             if not chests[name] or not chests[name].items then return end
             local citem = chests[name].items[idname]
             if not citem then return end
             vRP.prompt(source, lang.inventory.chest.take.prompt({citem.amount}), "", function(player, amount)
                 if not chests[name] or chests[name].user_id ~= user_id or not chests[name].items then return end
                 local current_citem_ref = chests[name].items[idname]
                 if not current_citem_ref then return end
                 amount = parseInt(amount)
                 if amount >= 0 and amount <= current_citem_ref.amount then
                     local new_weight = vRP.getInventoryWeight(user_id) + vRP.getItemWeight(idname) * amount
                     if new_weight <= vRP.getInventoryMaxWeight(user_id) then
                         vRP.giveInventoryItem(user_id, idname, amount, true)
                         current_citem_ref.amount = current_citem_ref.amount - amount
                         if current_citem_ref.amount <= 0 then chests[name].items[idname] = nil end
                         if cb_out then cb_out(idname, amount) end
                         vRP.closeMenu(player) -- Close the prompt ONLY
                     else vRPclient.notify(source, {lang.inventory.full()}) end
                 else vRPclient.notify(source, {lang.common.invalid_value()}) end
             end)
          end

          -- Callback for Put action
          local cb_put = function(idname)
             if not chests[name] or not chests[name].items then return end
             vRP.prompt(source, lang.inventory.chest.put.prompt({vRP.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
                 if not chests[name] or chests[name].user_id ~= user_id or not chests[name].items then return end
                 amount = parseInt(amount)
                 local current_chest_weight = vRP.computeItemsWeight(chests[name].items)
                 local new_weight = current_chest_weight + vRP.getItemWeight(idname) * amount
                 if new_weight <= max_weight then
                     if amount >= 0 and vRP.tryGetInventoryItem(user_id, idname, amount, true) then
                         local citem = chests[name].items[idname]
                         if citem ~= nil then citem.amount = citem.amount + amount
                         else chests[name].items[idname] = {amount = amount} end
                         if cb_in then cb_in(idname, amount) end
                         vRP.closeMenu(player) -- Close the prompt ONLY
                     end
                 else vRPclient.notify(source, {lang.inventory.chest.full()}) end
             end)
          end

          -- Callback for Trash action
          local cb_trash = function(idname)
              if not chests[name] or not chests[name].items then return end
              local citem = chests[name].items[idname]
              if not citem then return end
              vRP.prompt(source, lang.inventory.chest.trash.prompt({citem.amount, vRP.getItemName(idname)}), "", function(player, amount)
                  if not chests[name] or chests[name].user_id ~= user_id or not chests[name].items then return end
                  local current_citem_ref = chests[name].items[idname]
                  if not current_citem_ref then return end
                  amount = parseInt(amount)
                  if amount > 0 and amount <= current_citem_ref.amount then
                      current_citem_ref.amount = current_citem_ref.amount - amount
                      if current_citem_ref.amount <= 0 then chests[name].items[idname] = nil end
                      vRPclient.notify(player, {lang.inventory.chest.trash.done({amount, vRP.getItemName(idname)})})
                      vRPclient.playAnim(player, {true, {{"pickup_object", "pickup_low", 1}}, false})
                      vRP.closeMenu(player) -- Close the prompt ONLY
                  else vRPclient.notify(source, {lang.common.invalid_value()}) end
              end)
          end

          -- --- Main Menu Definition ---

          local function open_main_menu()
              -- Rebuild the menu definition before opening
              main_chest_menu = {
                  name=menu_title,
                  css={top="75px", header_color="rgba(0,255,125,0.75)"}
              }

              -- Take menu entry
              main_chest_menu[lang.inventory.chest.take.title()] = { function(player, choice)
                  if not chests[name] then return end -- Add check
                  local submenu = build_itemlist_menu(lang.inventory.chest.take.title(), chests[name].items, cb_take)
                  local weight = vRP.computeItemsWeight(chests[name].items or {}) -- Add safety check for items
                  local hue = math.floor(math.max(125*(1 - weight/max_weight), 0))
                  submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f", weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f", weight), max_weight})}
                  submenu.onclose = function()
                      close_count = close_count - 1
                      if chests[name] then open_main_menu() end -- Reopen main menu correctly
                  end
                  close_count = close_count + 1
                  vRP.openMenu(player, submenu)
              end }

              -- Put menu entry
              main_chest_menu[lang.inventory.chest.put.title()] = { function(player, choice)
                  local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_put) -- Player inventory
                  local weight = vRP.computeItemsWeight(data.inventory)
                  local p_max_weight = vRP.getInventoryMaxWeight(user_id)
                  local hue = math.floor(math.max(125*(1 - weight/p_max_weight), 0))
                  submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f", weight/p_max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f", weight), p_max_weight})}
                  submenu.onclose = function()
                      close_count = close_count - 1
                      if chests[name] then open_main_menu() end -- Reopen main menu correctly
                  end
                  close_count = close_count + 1
                  vRP.openMenu(player, submenu)
              end }

              -- Trash menu entry
              main_chest_menu[lang.inventory.chest.trash.title()] = { function(player, choice)
                   if not chests[name] then return end -- Add check
                  local submenu = build_itemlist_menu(lang.inventory.chest.trash.title(), chests[name].items, cb_trash)
                  local weight = vRP.computeItemsWeight(chests[name].items or {}) -- Add safety check for items
                  local hue = math.floor(math.max(125*(1 - weight/max_weight), 0))
                  submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f", weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f", weight), max_weight})}
                  submenu.onclose = function()
                      close_count = close_count - 1
                      if chests[name] then open_main_menu() end -- Reopen main menu correctly
                  end
                  close_count = close_count + 1
                  vRP.openMenu(player, submenu)
              end }

              -- START >> Add Trash All Weighted Entry
              main_chest_menu[lang.inventory.chest.trash_weighted.title()] = { -- Assumes new lang entry: trash_weighted = { title = "Trash All Weighted" }
                  function(player, choice)
                      if not chests[name] or not chests[name].items then return end -- Safety check

                      local items_to_trash = {}
                      local weighted_count = 0
                      for item_id, item_data in pairs(chests[name].items) do
                          local item_weight = vRP.getItemWeight(item_id) or 0
                          if item_weight > 0 then
                              weighted_count = weighted_count + 1
                              table.insert(items_to_trash, item_id) -- Store IDs to trash
                          end
                      end

                      if weighted_count > 0 then
                          vRP.request(player, lang.inventory.chest.trash_weighted.confirm({weighted_count}), 30, function(player, ok) -- Assumes new lang entry: confirm = "Trash %s weighted item(s)?"
                              if ok then
                                  if not chests[name] or chests[name].user_id ~= user_id or not chests[name].items then return end -- Re-check validity after request

                                  local actually_trashed = 0
                                  for _, item_id_to_trash in pairs(items_to_trash) do
                                      if chests[name].items[item_id_to_trash] then -- Check if item still exists
                                          chests[name].items[item_id_to_trash] = nil -- Remove from runtime state
                                          actually_trashed = actually_trashed + 1
                                      end
                                  end
                                  vRPclient.notify(player, {lang.inventory.chest.trash_weighted.done({actually_trashed})}) -- Assumes new lang entry: done = "Trashed %s weighted item(s)."
                                  vRPclient.playAnim(player, {true, {{"pickup_object", "pickup_low", 1}}, false})
                                  -- Refresh the main chest menu after trashing
                                  open_main_menu()
                              else
                                  vRPclient.notify(player, {lang.common.request_refused()}) -- Assumes: request_refused = "Request refused."
                              end
                          end)
                      else
                          vRPclient.notify(player, {lang.inventory.chest.trash_weighted.none()}) -- Assumes new lang entry: none = "No weighted items found to trash."
                      end
                  end,
                  lang.inventory.chest.trash_weighted.description() -- Assumes new lang entry: description = "Trash all items with weight > 0. Requires confirmation."
              }
              -- END >> Add Trash All Weighted Entry

              -- Main menu close behaviour
              main_chest_menu.onclose = function()
                  if close_count == 0 then
                       if chests[name] and chests[name].user_id == user_id then
                           vRP.setSData("chest:"..name, json.encode(chests[name].items))
                           chests[name] = nil -- Release chest
                           if cb_close then cb_close() end
                       end
                  end
              end

              -- Open the menu
              vRP.openMenu(source, main_chest_menu)

          end -- End of open_main_menu function definition

          -- Initial opening of the menu
          open_main_menu()

      end) -- End of getSData callback
    end
  end
end

function vRP.getTrunkSize(vehicle_name)
  local trunk_sizes = {
      ["car1"] = 50,
      ["adder"] = 250,
      ["mk15"] = 6900,
      ["trailerlarge"] = 	9000,
    
      -- Add more vehicle names and their corresponding trunk sizes
  }
  return trunk_sizes[vehicle_name] or 0
end

function vRP.getActualChestSize(user_id, size)
  if vRP.hasPermission(user_id, "vip") then
    return size * 1.5
  else
    return size
  end
end

function vRP.buildItemlistMenu(title, items, cb_take, cb_take_stack)
  local menudata = {
    name = title,
    css = {top = "75px", header_color = "rgba(255,125,0,0.75)"}
  }

  for k, v in pairs(items) do
    local take_line = string.format("Take <span style='color: green;'>%s</span>", k)
    local take_all_line = string.format("Take All <span style='color: green;'>%s</span>", k)
    
    menudata[take_line] = {
      function(player, choice)
        cb_take(k)
      end, 
      "Take " .. v.amount .. " " .. k
    }
    
    menudata[take_all_line] = {
      function(player, choice)
        cb_take_stack(k)
      end, 
      "Take all " .. v.amount .. " " .. k
    }
  end

  return menudata
end

-- Add this function to properly handle transformer to vehicle trunk
function vRP.transformerToVehicleTrunk(user_id, transformer, vehicle_id)
  local data = vRP.getUserDataTable(user_id)
  if data and transformer then
    for idname, item in pairs(transformer) do
      if item.amount > 0 then
        vRP.tryGetInventoryItem(user_id, idname, item.amount, false)
        vRP.giveInventoryItemToVehicle(user_id, vehicle_id, idname, item.amount, false)
      end
    end
  end
end
