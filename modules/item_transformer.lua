local cfg = module("cfg/item_transformers")
local cfg_inventory = module("cfg/inventory") -- Added inventory config
local lang = vRP.lang

-- api

local transformers = {}
local last_transformer_entered_by_player = {} -- Store last transformer entered per user_id

local function tr_remove_player(tr, player) -- remove player from transforming
    local recipe = tr.players[player] or ""
    tr.players[player] = nil -- dereference player
    vRPclient.removeProgressBar(player, {"vRP:tr:"..tr.name})
    vRP.closeMenu(player)

    -- onstop
    if tr.itemtr.onstop then tr.itemtr.onstop(player, recipe) end
end

function vRP.transformerStep(name, player, player_source)
    local user_id = vRP.getUserId(player_source)
    local def = transformers[name]
    if user_id and def and def.items_in and def.items_out then
        -- check all input items
        local all_items = true
        for k, v in pairs(def.items_in) do
            if vRP.getInventoryItemAmount(user_id, k) < v then
                all_items = false
                break
            end
        end

        if all_items then
            -- Check for nearby vehicles first
            vRPclient.getNearbyOwnedVehicles(player_source, {50}, function(ok_vehicles, vehicles_list)
                if ok_vehicles and #vehicles_list > 0 then
                    -- Create vehicle selection menu
                    local vehicle_menu = {name = "Select Trunk for Products", css={top="75px",header_color="rgba(0,200,255,0.75)"}}
                    
                    for _, veh_info in pairs(vehicles_list) do
                        local vtype = veh_info[1]
                        local name = veh_info[2]
                        local display_name = veh_info[3]
                        local dist = veh_info[4]
                        local chest_id = "chest:u"..user_id.."veh_"..string.lower(name)
                        local max_trunk = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight
                        max_trunk = vRP.getActualChestSize(user_id, max_trunk)

                        vehicle_menu[display_name .. " ("..string.format("%.1f", dist).."m)"] = {
                            function(player, choice)
                                -- Store selected vehicle info
                                local selected_vehicle = {
                                    chest_id = chest_id,
                                    display_name = display_name,
                                    max_trunk = max_trunk
                                }

                                -- Function to process items continuously
                                local function process_items()
                                    vRP.getSData(chest_id, function(trunk_json)
                                        local trunk_data = json.decode(trunk_json) or {}
                                        local current_trunk_w = vRP.computeItemsWeight(trunk_data)
                                        local remaining_capacity = max_trunk - current_trunk_w
                                        
                                        -- Calculate weight of one unit of output items
                                        local unit_weight = 0
                                        for item_id, amount in pairs(def.items_out) do
                                            unit_weight = unit_weight + (vRP.getItemWeight(item_id) * amount)
                                        end

                                        if remaining_capacity >= unit_weight then
                                            -- Take input items
                                            for k, v in pairs(def.items_in) do
                                                vRP.tryGetInventoryItem(user_id, k, v, true)
                                            end

                                            -- Add one unit to trunk
                                            for item_id, amount in pairs(def.items_out) do
                                                if trunk_data[item_id] then
                                                    trunk_data[item_id].amount = trunk_data[item_id].amount + amount
                                                else
                                                    trunk_data[item_id] = {amount = amount}
                                                end
                                            end
                                            vRP.setSData(chest_id, json.encode(trunk_data))

                                            -- Update progress bar
                                            local new_weight = vRP.computeItemsWeight(trunk_data)
                                            local fill_percentage = (new_weight / max_trunk) * 100
                                            vRPclient.setProgressBarValue(player_source, {"vRP:tr:"..name, math.floor(fill_percentage)})
                                            vRPclient.setProgressBarText(player_source, {"vRP:tr:"..name, "Filling trunk: "..math.floor(new_weight).."/"..max_trunk.."kg"})

                                            -- Check if there are more items to process
                                            local has_more_items = false
                                            for k, v in pairs(def.items_in) do
                                                if vRP.getInventoryItemAmount(user_id, k) >= v then
                                                    has_more_items = true
                                                    break
                                                end
                                            end

                                            if has_more_items then
                                                -- Continue processing this trunk if there's space
                                                if remaining_capacity - unit_weight >= unit_weight then
                                                    process_items() -- Process next unit immediately
                                                else
                                                    -- Trunk is full, check if there are more vehicles
                                                    vRPclient.notify(player_source, {"~y~Trunk is full"})
                                                    vRPclient.removeProgressBar(player_source, {"vRP:tr:"..name})
                                                    
                                                    -- Check for more vehicles
                                                    vRPclient.getNearbyOwnedVehicles(player_source, {50}, function(ok_vehicles, new_vehicles_list)
                                                        if ok_vehicles and #new_vehicles_list > 0 then
                                                            vRPclient.notify(player_source, {"~y~Select another vehicle for remaining items"})
                                                            vRP.openMenu(player_source, vehicle_menu)
                                                        else
                                                            vRPclient.notify(player_source, {"~r~No more vehicle trunks available"})
                                                        end
                                                    end)
                                                end
                                            else
                                                -- No more items to process
                                                vRPclient.notify(player_source, {"~g~All items processed"})
                                                vRPclient.removeProgressBar(player_source, {"vRP:tr:"..name})
                                            end
                                        else
                                            -- Trunk is full, check if there are more vehicles
                                            vRPclient.notify(player_source, {"~y~Trunk is full"})
                                            vRPclient.removeProgressBar(player_source, {"vRP:tr:"..name})
                                            
                                            -- Check for more vehicles
                                            vRPclient.getNearbyOwnedVehicles(player_source, {50}, function(ok_vehicles, new_vehicles_list)
                                                if ok_vehicles and #new_vehicles_list > 0 then
                                                    vRPclient.notify(player_source, {"~y~Select another vehicle for remaining items"})
                                                    vRP.openMenu(player_source, vehicle_menu)
                                                else
                                                    vRPclient.notify(player_source, {"~r~No more vehicle trunks available"})
                                                end
                                            end)
                                        end
                                    end)
                                end

                                -- Start the transformation process
                                vRPclient.setProgressBar(player_source, {"vRP:tr:"..name, "center", "Filling trunk...", 0, 200, 255, 0})
                                process_items()
                            end,
                            "Use trunk (~"..max_trunk.."kg capacity)"
                        }
                    end

                    -- Add a close option to the menu
                    vehicle_menu["Close"] = {function(player, choice)
                        vRP.closeMenu(player)
                    end}

                    -- Open the menu
                    vRP.openMenu(player_source, vehicle_menu)
                else
                    -- No vehicles nearby, try player inventory
                    local current_weight = vRP.getInventoryWeight(user_id)
                    local max_weight = vRP.getInventoryMaxWeight(user_id)
                    local output_weight = 0
                    
                    for item_id, amount in pairs(def.items_out) do
                        output_weight = output_weight + (vRP.getItemWeight(item_id) * amount)
                    end

                    if current_weight + output_weight <= max_weight then
                        -- Add to player inventory
                        for k, v in pairs(def.items_out) do
                            vRP.giveInventoryItem(user_id, k, v, true)
                        end
                        vRPclient.notify(player_source, {lang.item_transformer.done()})
                    else
                        vRPclient.notify(player_source, {lang.inventory.full()})
                    end
                end
            end)
        else
            vRPclient.notify(player_source, {lang.item_transformer.not_enough()})
        end
    end
end

local function tr_add_player(tr, player, recipe) -- add player to transforming
    -- Check if player is already transforming something else in THIS transformer
    if tr.players[player] and tr.players[player] ~= recipe then
         vRPclient.notify(player, {"~r~Already processing another recipe. Please wait or stop."})
         return -- Don't start new recipe if already busy with another
    elseif not tr.players[player] then -- Only set if not already processing this recipe
    tr.players[player] = recipe -- reference player as using transformer
    end
    vRPclient.setProgressBar(player, {"vRP:tr:"..tr.name, "center", recipe.."...", tr.itemtr.r, tr.itemtr.g, tr.itemtr.b, 0})

    -- onstart
    if tr.itemtr.onstart then tr.itemtr.onstart(player, recipe) end
end

local function tr_tick(tr)
    local player_transforms = {}
    for p_key, p_val in pairs(tr.players) do player_transforms[p_key] = p_val end

    for player_key, recipe_name in pairs(player_transforms) do
        local user_id = vRP.getUserId(tonumber(player_key))
        local player_source = tonumber(player_key)

        if not user_id or not tr.itemtr.recipes[recipe_name] or not tr.players[player_key] then
            goto continue_player_loop
        end

        local recipe = tr.itemtr.recipes[recipe_name]
        local is_filler = recipe.filler or false
        local can_process_units = (is_filler and tr.units < tr.itemtr.max_units) or (not is_filler and tr.units > 0)

        if not can_process_units then
            goto continue_player_loop
        end

        -- Check player money first
        if vRP.getMoney(user_id) < recipe.in_money then
            goto continue_player_loop
        end

        -- Check player inventory for reagents
        local player_has_reagents = true
        local required_reagents = recipe.reagents or {}
        for item_id, amount in pairs(required_reagents) do
            if vRP.getInventoryItemAmount(user_id, item_id) < amount then
                player_has_reagents = false
                break
            end
        end

        -- Calculate product weights
        local product_items = recipe.products or {}
        local products_weight_table = {}
        for item_id, amount in pairs(product_items) do products_weight_table[item_id] = {amount=amount} end
        local products_total_weight = vRP.computeItemsWeight(products_weight_table)

        -- Calculate reagent weights
        local reagent_weight_table = {}
        for item_id, amount in pairs(required_reagents) do reagent_weight_table[item_id] = {amount=amount} end
        local reagents_total_weight = vRP.computeItemsWeight(reagent_weight_table)

        if player_has_reagents then
            -- Check for nearby vehicles
            vRPclient.getNearbyOwnedVehicles(player_source, {50}, function(ok_vehicles, vehicles_list)
                if ok_vehicles and #vehicles_list > 0 then
                    -- Create vehicle selection menu
                    local vehicle_menu = {name = "Select Trunk for Products", css={top="75px",header_color="rgba(0,200,255,0.75)"}}
                    
                    for _, veh_info in pairs(vehicles_list) do
                        local vtype = veh_info[1]
                        local name = veh_info[2]
                        local display_name = veh_info[3]
                        local dist = veh_info[4]
                        local chest_id = "chest:u"..user_id.."veh_"..string.lower(name)
                        local max_trunk = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight
                        max_trunk = vRP.getActualChestSize(user_id, max_trunk)

                        vehicle_menu[display_name .. " ("..string.format("%.1f", dist).."m)"] = {
                            function(player, choice)
                                -- Store selected vehicle info
                                local selected_vehicle = {
                                    chest_id = chest_id,
                                    display_name = display_name,
                                    max_trunk = max_trunk
                                }

                                -- Function to process items continuously
                                local function process_items()
                                    vRP.getSData(chest_id, function(trunk_json)
                                        local trunk_data = json.decode(trunk_json) or {}
                                        local current_trunk_w = vRP.computeItemsWeight(trunk_data)
                                        local remaining_capacity = max_trunk - current_trunk_w

                                        if remaining_capacity >= products_total_weight then
                                            -- Consume resources and add to trunk
                                            if recipe.in_money > 0 then vRP.tryPayment(user_id, recipe.in_money) end
                                            for item_id, amount in pairs(required_reagents) do
                                                vRP.tryGetInventoryItem(user_id, item_id, amount, true)
                                            end

                                            for item_id, amount in pairs(product_items) do
                                                if trunk_data[item_id] then
                                                    trunk_data[item_id].amount = trunk_data[item_id].amount + amount
                                                else
                                                    trunk_data[item_id] = {amount = amount}
                                                end
                                            end
                                            vRP.setSData(chest_id, json.encode(trunk_data))
                                            vRPclient.notify(player_source, {"~g~Items added to trunk: ~b~" .. display_name})

                                            -- Update transformer state
                                            if is_filler then tr.units = tr.units + 1 else tr.units = tr.units - 1 end
                                            if tr.itemtr.onstep then tr.itemtr.onstep(player_source, recipe_name) end

                                            -- Check if there are more items to process
                                            local has_more_items = false
                                            for k, v in pairs(required_reagents) do
                                                if vRP.getInventoryItemAmount(user_id, k) >= v then
                                                    has_more_items = true
                                                    break
                                                end
                                            end

                                            if has_more_items then
                                                -- Continue processing this trunk if there's space
                                                if remaining_capacity - products_total_weight >= products_total_weight then
                                                    process_items() -- Process next unit immediately
                                                else
                                                    -- Trunk is full, check if there are more vehicles
                                                    vRPclient.notify(player_source, {"~y~Trunk is full"})
                                                    
                                                    -- Check for more vehicles
                                                    vRPclient.getNearbyOwnedVehicles(player_source, {50}, function(ok_vehicles, new_vehicles_list)
                                                        if ok_vehicles and #new_vehicles_list > 0 then
                                                            vRPclient.notify(player_source, {"~y~Select another vehicle for remaining items"})
                                                            vRP.openMenu(player_source, vehicle_menu)
                                                        else
                                                            vRPclient.notify(player_source, {"~r~No more vehicle trunks available"})
                                                        end
                                                    end)
                                                end
                                            else
                                                -- No more items to process
                                                vRPclient.notify(player_source, {"~g~All items processed"})
                                            end
                                        else
                                            -- Trunk is full, check if there are more vehicles
                                            vRPclient.notify(player_source, {"~y~Trunk is full"})
                                            
                                            -- Check for more vehicles
                                            vRPclient.getNearbyOwnedVehicles(player_source, {50}, function(ok_vehicles, new_vehicles_list)
                                                if ok_vehicles and #new_vehicles_list > 0 then
                                                    vRPclient.notify(player_source, {"~y~Select another vehicle for remaining items"})
                                                    vRP.openMenu(player_source, vehicle_menu)
                                                else
                                                    vRPclient.notify(player_source, {"~r~No more vehicle trunks available"})
                                                end
                                            end)
                                        end
                                    end)
                                end

                                -- Start the transformation process
                                process_items()
                            end,
                            "Use trunk (~"..max_trunk.."kg capacity)"
                        }
                    end

                    -- Add a close option to the menu
                    vehicle_menu["Close"] = {function(player, choice)
                        vRP.closeMenu(player)
                    end}

                    -- Open the menu
                    vRP.openMenu(player_source, vehicle_menu)
                else
                    -- No vehicles nearby, try player inventory
                    local current_weight = vRP.getInventoryWeight(user_id)
                    local max_weight = vRP.getInventoryMaxWeight(user_id)

                    if current_weight + products_total_weight <= max_weight then
                        -- Consume resources and add to player inventory
                        if recipe.in_money > 0 then vRP.tryPayment(user_id, recipe.in_money) end
                        for item_id, amount in pairs(required_reagents) do
                            vRP.tryGetInventoryItem(user_id, item_id, amount, true)
                        end

                        for item_id, amount in pairs(product_items) do
                            vRP.giveInventoryItem(user_id, item_id, amount, true)
                        end

                        -- Update transformer state
                        if is_filler then tr.units = tr.units + 1 else tr.units = tr.units - 1 end
                        if tr.itemtr.onstep then tr.itemtr.onstep(player_source, recipe_name) end
                    else
                        vRPclient.notify(player_source, {lang.inventory.full()})
                    end
                end
            end)
        end

        ::continue_player_loop::
    end

    -- Update progress bars
    for player_key, _ in pairs(tr.players) do
        local player_source_prog = tonumber(player_key)
        if player_source_prog then
            local current_tr_prog = transformers[tr.name]
            if current_tr_prog and current_tr_prog.players[player_key] then
                local current_units = current_tr_prog.units
                local max_units = current_tr_prog.itemtr.max_units
                local current_recipe_name = current_tr_prog.players[player_key]
                local is_current_filler = current_tr_prog.itemtr.recipes[current_recipe_name] and current_tr_prog.itemtr.recipes[current_recipe_name].filler

                vRPclient.setProgressBarValue(player_source_prog, {"vRP:tr:"..tr.name, math.floor(current_units/max_units*100.0)})
                if current_units > 0 or is_current_filler then
                    vRPclient.setProgressBarText(player_source_prog, {"vRP:tr:"..tr.name, current_recipe_name.."... "..current_units.."/"..max_units})
                else
                    vRPclient.setProgressBarText(player_source_prog, {"vRP:tr:"..tr.name, "empty"})
                end
            else
                vRPclient.removeProgressBar(player_source_prog, {"vRP:tr:"..tr.name})
            end
        end
    end
end

local function bind_tr_area(player, tr) -- add tr area to client
    vRP.setArea(player, "vRP:tr:"..tr.name, tr.itemtr.x, tr.itemtr.y, tr.itemtr.z, tr.itemtr.radius, tr.itemtr.height, tr.enter, tr.leave)
end

local function unbind_tr_area(player, tr) -- remove tr area from client
    vRP.removeArea(player, "vRP:tr:"..tr.name)
end

-- add an item transformer
-- name: transformer id name
-- itemtr: item transformer definition table
--- name
--- max_units
--- units_per_minute
--- x, y, z, radius, height (area properties)
--- r, g, b (color)
--- action
--- description
--- in_money
--- out_money
--- reagents: items as idname => amount
--- products: items as idname => amount
function vRP.setItemTransformer(name, itemtr)
    vRP.removeItemTransformer(name) -- remove pre-existing transformer

    local tr = {itemtr = itemtr}
    tr.name = name
    transformers[name] = tr

    -- init transformer
    tr.units = itemtr.units or 0
    tr.players = {}

    -- build menu
    tr.menu = {name = itemtr.name, css = {top = "75px", header_color = "rgba("..itemtr.r..","..itemtr.g..","..itemtr.b..",0.75)"}}

    -- build recipes
    for action, recipe in pairs(tr.itemtr.recipes) do
        local info = "<br /><br />"
        if recipe.in_money > 0 then info = info.."- "..recipe.in_money end
        for k, v in pairs(recipe.reagents) do
            local item = vRP.items[k]
            if item then
                info = info.."<br />"..v.." "..item.name
            end
        end
        info = info.."<br /><span style=\"color: rgb(0,255,125)\">=></span>"
        if recipe.out_money > 0 then info = info.."<br />+ "..recipe.out_money end
        for k, v in pairs(recipe.products) do
            local item = vRP.items[k]
            if item then
                info = info.."<br />"..v.." "..item.name
            end
        end
        for k, v in pairs(recipe.aptitudes or {}) do
            local parts = splitString(k, ".")
            if #parts == 2 then
                local def = vRP.getAptitudeDefinition(parts[1], parts[2])
                if def then
                    info = info.."<br />[EXP] "..v.." "..vRP.getAptitudeGroupTitle(parts[1]).."/"..def[1]
                end
            end
        end

        tr.menu[action] = {function(player, choice)
            -- Add a check before starting: Only allow if NOT currently transforming or transforming the SAME recipe already
            local user_id = vRP.getUserId(player)
            if user_id and tr.players[player] and tr.players[player] ~= action then
                 vRPclient.notify(player, {"~r~Processing another recipe. Stop it first."})
            else
                tr_add_player(tr, player, action)
            end
            end, recipe.description..info}
    end

    -- ADD Stop Option
    tr.menu[lang.itemtr.stop_transforming.title()] = { -- Assumes lang entry: stop_transforming = {title="Stop Transforming"}
        function(player, choice)
            tr_remove_player(tr, player) -- Call the existing function to stop and clear progress bar/menu
            vRPclient.notify(player, {lang.itemtr.stop_transforming.stopped()}) -- Assumes lang entry: stopped="Transformation stopped."
             -- Optional: Immediately re-open the menu after stopping
             -- Wait a fraction of a second to ensure closeMenu in tr_remove_player finishes
             SetTimeout(100, function()
                 if transformers[tr.name] then -- Check if it still exists
                     vRP.openMenu(player, transformers[tr.name].menu)
                 end
             end)
        end,
    lang.itemtr.stop_transforming.description() -- Assumes lang entry: description="Stop the current transformation process."
    }

    -- build area
    tr.enter = function(player, area)
        local user_id = vRP.getUserId(player)
        if user_id ~= nil and vRP.hasPermissions(user_id, itemtr.permissions or {}) then
            last_transformer_entered_by_player[user_id] = tr.name -- Store the transformer name
            vRP.openMenu(player, tr.menu) -- open menu
        end
    end

    tr.leave = function(player, area)
        local user_id = vRP.getUserId(player)
        if user_id then
             -- Check if they are leaving the one they last entered
             if last_transformer_entered_by_player[user_id] == tr.name then
                 last_transformer_entered_by_player[user_id] = nil -- Clear when leaving
             end
        end
        tr_remove_player(tr, player) -- Existing leave logic
    end

    -- bind tr area to all already spawned players
    for k, v in pairs(vRP.rusers) do
        local source = vRP.getUserSource(k)
        if source ~= nil then
            bind_tr_area(source, tr)
        end
    end
end

-- remove an item transformer
function vRP.removeItemTransformer(name)
    local tr = transformers[name]
    if tr then
        -- copy players (to remove while iterating)
        local players = {}
        for k, v in pairs(tr.players) do
            players[k] = v
        end

        for k, v in pairs(players) do -- remove players from transforming
            tr_remove_player(tr, k)
        end

        -- remove tr area from all already spawned players
        for k, v in pairs(vRP.rusers) do
            local source = vRP.getUserSource(k)
            if source ~= nil then
                unbind_tr_area(source, tr)
            end
        end

        transformers[name] = nil
    end
end

-- task: transformers ticks (every 3 seconds)
local function transformers_tick()
    SetTimeout(0, function() -- error death protection for transformers_tick()
        for k, tr in pairs(transformers) do
            -- Need to wrap the call to tr_tick in a coroutine or similar
            -- if the async operations inside it might yield, but standard timer functions
            -- usually handle this. Let's assume SetTimeout handles context correctly.
            -- If issues arise (errors about yielding), wrap tr_tick(tr) in Citizen.CreateThread
             Citizen.CreateThread(function()
            tr_tick(tr)
             end)
        end
    end)

    SetTimeout(3000, transformers_tick)
end
transformers_tick()

-- task: transformers unit regeneration
local function transformers_regen()
    for k, tr in pairs(transformers) do
        tr.units = tr.units + tr.itemtr.units_per_minute
        if tr.units >= tr.itemtr.max_units then tr.units = tr.itemtr.max_units end
    end

    SetTimeout(60000, transformers_regen)
end
transformers_regen()

-- add transformers areas on player first spawn
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k, tr in pairs(transformers) do
            bind_tr_area(source, tr)
        end
    end
end)

-- STATIC TRANSFORMERS

SetTimeout(5, function()
    -- delayed to wait items loading
    -- load item transformers from config file
    for k, v in pairs(cfg.item_transformers) do
        vRP.setItemTransformer("cfg:"..k, v)
    end
end)

-- HIDDEN TRANSFORMERS

-- generate a random position for the hidden transformer
local function gen_random_position(positions)
    local n = #positions
    if n > 0 then
        return positions[math.random(1, n)]
    else
        return {0, 0, 0}
    end
end

local function hidden_placement_tick()
    vRP.getSData("vRP:hidden_trs", function(data)
        local hidden_trs = json.decode(data) or {}

        for k, v in pairs(cfg.hidden_transformers) do
            -- init entry
            local htr = hidden_trs[k]
            if htr == nil then
                hidden_trs[k] = {timestamp = parseInt(os.time()), position = gen_random_position(v.positions), units = 0}
                htr = hidden_trs[k]
            end

            -- remove hidden transformer if needs respawn
            if tonumber(os.time()) - htr.timestamp >= cfg.hidden_transformer_duration * 60 then
                htr.timestamp = parseInt(os.time())
                vRP.removeItemTransformer("cfg:"..k)
                -- generate new position
                htr.position = gen_random_position(v.positions)
            end

            -- spawn if unspawned
            if transformers["cfg:"..k] == nil then
                v.def.x = htr.position[1]
                v.def.y = htr.position[2]
                v.def.z = htr.position[3]
                v.def.units = htr.units

                vRP.setItemTransformer("cfg:"..k, v.def)
            end

            for _k, _v in pairs(transformers) do
                if _k == "cfg:"..k then
                    hidden_trs[k].units = _v.units
                end
            end
        end

        vRP.setSData("vRP:hidden_trs", json.encode(hidden_trs)) -- save hidden transformers
    end)

    SetTimeout(300000, hidden_placement_tick)
end
SetTimeout(5000, hidden_placement_tick) -- delayed to wait items loading

-- INFORMER

-- build informer menu
local informer_menu = {name = lang.itemtr.informer.title(), css = {top = "75px", header_color = "rgba(0,255,125,0.75)"}}

local function ch_informer_buy(player, choice)
    local user_id = vRP.getUserId(player)
    local tr = transformers["cfg:"..choice]
    local price = cfg.informer.infos[choice]

    if user_id ~= nil and tr ~= nil then
        if vRP.tryPayment(user_id, price) then
            vRPclient.setGPS(player, {tr.itemtr.x, tr.itemtr.y}) -- set gps marker
            vRPclient.notify(player, {lang.money.paid({price})})
            vRPclient.notify(player, {lang.itemtr.informer.bought()})
        else
            vRPclient.notify(player, {lang.money.not_enough()})
        end
    end
end

for k, v in pairs(cfg.informer.infos) do
    informer_menu[k] = {ch_informer_buy, lang.itemtr.informer.description({v})}
end

local function informer_enter(player, area)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRP.openMenu(player, informer_menu)
    end
end

local function informer_leave(player, area)
    vRP.closeMenu(player)
end

local function informer_placement_tick()
    local pos = gen_random_position(cfg.informer.positions)
    local x, y, z = table.unpack(pos)

    for k, v in pairs(vRP.rusers) do
        local player = vRP.getUserSource(tonumber(k))

        -- add informer blip/marker/area
        vRPclient.setNamedBlip(player, {"vRP:informer", x, y, z, cfg.informer.blipid, cfg.informer.blipcolor, lang.itemtr.informer.title()})
        vRPclient.setNamedMarker(player, {"vRP:informer", x, y, z - 1, 0.7, 0.7, 0.5, 0, 255, 125, 125, 150})
        vRP.setArea(player, "vRP:informer", x, y, z, 1, 1.5, informer_enter, informer_leave)
    end

    -- remove informer blip/marker/area after after a while
    SetTimeout(cfg.informer.duration * 60000, function()
        for k, v in pairs(vRP.rusers) do
            local player = vRP.getUserSource(tonumber(k))
            vRPclient.removeNamedBlip(player, {"vRP:informer"})
            vRPclient.removeNamedMarker(player, {"vRP:informer"})
            vRP.removeArea(player, "vRP:informer")
        end
    end)

    SetTimeout(cfg.informer.interval * 60000, informer_placement_tick)
end

SetTimeout(cfg.informer.interval * 60000, informer_placement_tick)

-- Menu builder for the main vRP menu
vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local last_transformer_name = last_transformer_entered_by_player[user_id]
    if last_transformer_name and transformers[last_transformer_name] then -- Check if player was recently at a known transformer
      local choices = {}
      choices[lang.itemtr.reopen_menu.title()] = { -- Assumes you add reopen_menu = {title="Re-open Transformer", description="Re-open the last transformer menu if nearby."} to your lang file
        function(player, choice)
          local current_user_id = vRP.getUserId(player)
          local current_last_transformer = last_transformer_entered_by_player[current_user_id]
          local transformer_def = current_last_transformer and transformers[current_last_transformer]

          if transformer_def then
            local tr_x = transformer_def.itemtr.x
            local tr_y = transformer_def.itemtr.y
            local tr_z = transformer_def.itemtr.z
            local interaction_radius = (transformer_def.itemtr.radius or 5.0) + 2.0 -- Use slightly larger radius for re-open check

            -- Check if player is still near the transformer
            vRPclient.isPlayerNearCoords(player, {tr_x, tr_y, tr_z, interaction_radius}, function(is_near)
              if is_near then
                vRP.openMenu(player, transformer_def.menu)
              else
                vRPclient.notify(player, {lang.itemtr.reopen_menu.not_near()}) -- Assumes lang file entry: not_near="Not near the last transformer."
                last_transformer_entered_by_player[current_user_id] = nil -- Clear if not near anymore
              end
            end)
          else
            vRPclient.notify(player, {lang.itemtr.reopen_menu.not_near()})
            last_transformer_entered_by_player[current_user_id] = nil -- Clear if transformer doesn't exist anymore
          end
        end,
        lang.itemtr.reopen_menu.description()
      }
      add(choices)
    end
  end
end)

-- Make sure to add these entries to your language file (e.g., vrp/cfg/lang/en.lua):
-- itemtr = {
--   ... existing entries ...
--   reopen_menu = {
--      title="Re-open Transformer",
--      description="Re-open the last transformer menu if nearby.",
--      not_near="Not near the last transformer."
--   }
-- }
