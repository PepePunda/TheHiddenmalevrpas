-- define items, see the Inventory API on github

local cfg = {}

-- see the manual to understand how to create parametric items
-- idname = {name or genfunc, description or genfunc, genfunc choices or nil, weight or genfunc}
-- a good practice is to create your own item pack file instead of adding items here
cfg.items = {
  ["weed"] = {"Weed", "Some weed.", nil, 0.01}, -- no choices
  
  -- Base materials
  ["logs"] = {"Logs", "Wooden logs.", nil, 10.0},
  ["planks"] = {"Planks", "Wooden planks.", nil, 5.0},
  ["sawdust"] = {"Sawdust", "Dust from sawing wood.", nil, 1.0},
  ["quarry_rubble"] = {"Quarry Rubble", "Rubble from a quarry.", nil, 150.0},
  ["gravel"] = {"Gravel", "Loose aggregation of rock fragments.", nil, 1.2},
  ["sand"] = {"Sand", "Granular material composed of finely divided rock and mineral particles.", nil, 1.0},
  ["flint"] = {"Flint", "A piece of flint.", nil, 0.5},
  ["cement_mix"] = {"Cement Mix", "Mixture for creating concrete.", nil, 2.0},
  ["concrete"] = {"Concrete", "Construction concrete.", nil, 2.5},
  ["untreated_water"] = {"Untreated Water", "Raw water.", nil, 1.0},
  ["treated_water"] = {"Treated Water", "Water treated for use.", nil, 1.0},
  ["toxic_waste"] = {"Toxic Waste", "Hazardous waste material.", nil, 5.0},
  ["recycled_trash"] = {"Recycled Trash", "Trash that has been recycled.", nil, 0.5},
  ["scrap_plastic"] = {"Scrap Plastic", "Recyclable plastic.", nil, 0.2},
  ["scrap_aluminum"] = {"Scrap Aluminum", "Recyclable aluminum.", nil, 0.3},
  ["scrap_tin"] = {"Scrap Tin", "Recyclable tin.", nil, 0.4},
  ["refined_aluminum"] = {"Refined Aluminum", "Purified aluminum material.", nil, 0.5},
  ["refined_tin"] = {"Refined Tin", "Purified tin material.", nil, 0.6},
  ["scrap_mercury"] = {"Scrap Mercury", "Recyclable mercury.", nil, 1.0},
  ["amalgam"] = {"Amalgam", "Mixture of mercury and other metals.", nil, 1.2},
  ["rebar"] = {"Rebar", "Reinforcement bar for construction.", nil, 3.0},
  ["scrap_lead"] = {"Scrap Lead", "Recyclable lead.", nil, 1.5},
  ["refined_solder"] = {"Refined Solder", "Purified solder material.", nil, 0.5},
  ["batteries"] = {"Batteries", "Power storage units.", nil, 1.0},
  ["circuit_board"] = {"Circuit Board", "Electronic circuit board.", nil, 0.5},
  ["computer"] = {"Computer", "Electronic computing device.", nil, 5.0},
  ["scrap_gold"] = {"Scrap Gold", "Recyclable gold.", nil, 0.2},
  ["recycled_electronics"] = {"Recycled Electronics", "Electronic waste recycled.", nil, 1.0},
  ["copper_wire"] = {"Copper Wire", "Wire made from copper.", nil, 0.3},
  ["Tools"] = {"Tools", "buy tools that can be sold at the tool buyer.", nil, 1.0},
  ["Erasers"] = {"Erasers", "buy Erasers that can be sold at the Erasers buyer.", nil, 3.0},
}

-- load more items function
local function load_item_pack(name)
  local items = module("cfg/item/"..name)
  if items then
    for k,v in pairs(items) do
      cfg.items[k] = v
    end
  else
    print("[vRP] item pack ["..name.."] not found")
  end
end

-- PACKS
load_item_pack("required")
load_item_pack("food")
load_item_pack("drugs")

return cfg
