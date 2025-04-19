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
  -- Tools and Basic Cargo Items
["tools"] = {"Tools", "Basic cargo item used in trucking and crafting.", nil, 1.0},
["erasers"] = {"Erasers", "Mid-tier cargo item for trucking jobs (heavier than tools).", nil, 3.0},
["mechanic_hammer"] = {"Mechanic Hammer", "Tool crafted via trucking, used for mechanic repair jobs.", nil, 5.0},
["mechanic_wrench"] = {"Mechanic Wrench", "Tool crafted via trucking, used for mechanic engine repairs.", nil, 5.0},

-- Job Materials and Chemicals
["acid"] = {"Acid", "Industrial chemical used in multiple crafting processes.", nil, 5.0},
["explosives"] = {"Explosives", "Highly volatile explosives used in mining and military tasks.", nil, 250.0},
["chemicals"] = {"Chemicals", "Bulk chemical compounds from petrochemical trucking.", nil, 25.0},
["sulfur"] = {"Sulfur", "Refined sulfur powder from chemical processing.", nil, 1.0},

-- Fuels (Refinery Outputs and Refined Fuels)
["diesel"] = {"Diesel", "Unrefined diesel fuel obtained from the refinery.", nil, 25.0},
["diesel_fuel"] = {"Diesel Fuel", "Refined diesel fuel ready for vehicle use.", nil, 2.5},
["petrol"] = {"Petrol", "Unrefined gasoline (petrol) from the refinery.", nil, 25.0},
["petrol_fuel"] = {"Petrol Fuel", "Refined petrol fuel for vehicles.", nil, 2.5},
["kerosene"] = {"Kerosene", "Refined aviation fuel (kerosene) from the refinery.", nil, 25.0},
["helicopter_fuel"] = {"Helicopter Fuel", "Refined fuel formulated for helicopters.", nil, 2.5},
["propane"] = {"Propane", "Refined propane gas extracted at the refinery.", nil, 25.0},
["boat_fuel"] = {"Boat Fuel", "Refined fuel designed for boat engines.", nil, 2.5},
["plane_fuel"] = {"Plane Fuel", "Refined aviation fuel for airplanes.", nil, 2.5},

-- Mining and Raw Materials
["iron_ore"] = {"Iron Ore", "Raw iron ore mined from mineral deposits.", nil, 1.0},
["iron_ore_voucher"] = {"Iron Ore Voucher", "Exchange voucher for iron ore from mining.", nil, 0.0},
["copper_ore"] = {"Copper Ore", "Raw copper ore mined from mineral deposits.", nil, 1.0},
["copper_ore_voucher"] = {"Copper Ore Voucher", "Exchange voucher for copper ore from mining.", nil, 0.0},
["raw_gas"] = {"Raw Gas", "Unrefined natural gas collected from gas drilling.", nil, 150.0},
["raw_ore_mix"] = {"Raw Ore Mix", "Mixed unprocessed ore materials from mining.", nil, 15.0},
["sandstone"] = {"Sandstone", "Cut sandstone rock, obtained from quarrying.", nil, 5.0},

-- Refined Metals and Alloys
["hardened_steel"] = {"Hardened Steel", "Hardened steel alloy used in advanced crafting.", nil, 10.0},
["bronze_alloy"] = {"Bronze Alloy", "Alloy of copper and tin, used for crafting.", nil, 10.0},
["refined_copper"] = {"Refined Copper", "Purified copper ingot material.", nil, 10.0},
["refined_gold"] = {"Refined Gold", "Purified gold ingot material.", nil, 10.0},
["refined_zinc"] = {"Refined Zinc", "Purified zinc material.", nil, 10.0},
["titanium"] = {"Titanium", "Refined titanium metal ready for use.", nil, 10.0},
["titanium_ore"] = {"Titanium Ore", "Unprocessed titanium ore from mining.", nil, 1.0},

-- Vehicle Parts and Assemblies
["chassis"] = {"Chassis", "Vehicle chassis frame crafted at a vehicle parts plant.", nil, 80.0},
["vehicle_framework"] = {"Vehicle Framework", "Base vehicle framework for car assembly.", nil, 200.0},
["wheels"] = {"Wheels", "Set of vehicle wheel assemblies.", nil, 10.0},
["car_battery"] = {"Car Battery", "Standard vehicle battery unit.", nil, 20.0},
["traction_battery"] = {"Traction Battery", "High-capacity battery for electric vehicles.", nil, 50.0},
["repair_shop"] = {"Repair Shop", "Deployable vehicle repair station (portable garage).", nil, 100.0},
["upgrade_kit_voltic2"] = {"Upgrade Kit Voltic2", "Upgrade kit for the Voltic2 special vehicle.", nil, 20.0},

-- Shipped Vehicles (Vehicle Shipments Job Items)
["10f"] = {"10F", "Shipment of an Obey 10F vehicle (for Vehicle Shipments).", nil, 0.0},
["annis_zr350"] = {"Annis ZR-350", "Shipment of an Annis ZR-350 vehicle.", nil, 0.0},
["coil_savanna"] = {"Coil Savanna", "Shipment of a Coil Savanna vehicle.", nil, 0.0},
["hijak_vertice"] = {"Hijak Vertice", "Shipment of a Hijak Vertice vehicle.", nil, 0.0},
["hvy_nightshark"] = {"HVY Nightshark", "Shipment of an HVY Nightshark vehicle.", nil, 0.0},
["karin_futo"] = {"Karin Futo", "Shipment of a Karin Futo vehicle.", nil, 0.0},
["landstalker_xl"] = {"Landstalker XL", "Shipment of a Dundreary Landstalker XL vehicle.", nil, 0.0},

-- Wildlife and Hunting Products
["hide_bear"] = {"Hide Bear", "Tanned hide (pelt) from a bear.", nil, 5.0},
["hide_boar"] = {"Hide Boar", "Tanned hide (pelt) from a boar.", nil, 5.0},
["hide_coyote"] = {"Hide Coyote", "Tanned hide from a coyote.", nil, 5.0},
["hide_deer"] = {"Hide Deer", "Tanned deer hide (pelt).", nil, 5.0},
["hide_leopard"] = {"Hide Leopard", "Tanned hide from a leopard.", nil, 5.0},
["hide_lion"] = {"Hide Lion", "Tanned hide from a lion.", nil, 5.0},
["hide_mtlion"] = {"Hide Mtlion", "Tanned hide from a mountain lion.", nil, 5.0},
["hide_rabbit"] = {"Hide Rabbit", "Pelt obtained from a rabbit.", nil, 5.0},
["hide_rat"] = {"Hide Rat", "Pelt obtained from a rat.", nil, 5.0},
["hide_wolf"] = {"Hide Wolf", "Tanned hide from a wolf.", nil, 5.0},
["meat"] = {"Meat", "Raw meat obtained from hunting wildlife.", nil, 1.0},
["fish_meat"] = {"Fish Meat", "Raw fish meat from fishing.", nil, 1.0},
["premium_fish_meat"] = {"Premium Fish Meat", "High-quality fish meat (premium catch).", nil, 1.0},
["frozen_raw_meat"] = {"Frozen Raw Meat", "Frozen meat products ready for transport.", nil, 5.0},
["vegetables"] = {"Vegetables", "Fresh harvested vegetables (produce crate).", nil, 5.0},

-- Consumables and Miscellaneous
["airline_meal"] = {"Airline Meal", "Packaged meal prepared for airline passengers.", nil, 1.0},
["dairy_products"] = {"Dairy Products", "Crate of milk and assorted dairy goods.", nil, 5.0},
["jerry_can_empty"] = {"Jerry Can Empty", "An empty jerry can for fuel storage.", nil, 1.0},
["jewelry"] = {"Jewelry", "Assorted valuable jewelry items.", nil, 1.0},
["defib_kit"] = {"Defibrillator Kit", "Functional defib kit for emergency medical use.", nil, 5.0},
["empty_defib_kit"] = {"Empty Defib Kit", "Used defibrillator kit needing recharge.", nil, 5.0},
["pills"] = {"Pills", "Loose pills (medicine or narcotics).", nil, 0.01},
["pills_crate"] = {"Pills Crate", "Crate containing packaged pills.", nil, 1.0},
["box_of_empty_pill_capsules"] = {"Box of Empty Pill Capsules", "Box of empty capsules for pill manufacturing.", nil, 0.2},
["box_of_full_pill_capsules"] = {"Box of Full Pill Capsules", "Box of filled pill capsules ready for use.", nil, 0.3},
["methamphetamine"] = {"Methamphetamine", "An illegal stimulant drug (crystal meth).", nil, 0.01},
["raw_emeralds"] = {"Raw Emeralds", "Uncut and unpolished emerald gemstones.", nil, 10.0},
["rubber"] = {"Rubber", "Uncured rubber material from petrochemical refining.", nil, 5.0},
["cardboard"] = {"Cardboard", "Cardboard material used for packaging.", nil, 0.5},
["ceramic_tiles"] = {"Ceramic Tiles", "Stack of ceramic tiles for construction.", nil, 5.0},
["food_shipment"] = {"Food Shipment", "Bulk shipment of food supplies.", nil, 10.0},
["glass"] = {"Glass", "Refined glass material for manufacturing.", nil, 2.0},
["scrap_copper"] = {"Scrap Copper", "Recyclable copper scrap material.", nil, 0.4},
["shipping_container"] = {"Shipping Container", "A large freight shipping container.", nil, 0.0},
["pacific_standard_bank"] = {"Pacific Standard Bank", "Confidential item related to the Pacific Standard Bank.", nil, 0.0}

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
