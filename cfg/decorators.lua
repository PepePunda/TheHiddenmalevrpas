local DECOR = {
    FLOAT = 1,
    BOOL = 2,
    INT = 3,
    UNK = 4,
    TIME = 5,
}

local DECORATORS = {

    -- Custom Plate handling
    ["omni_custom_plate"] = {DECOR.BOOL, "Has Custom Plate"}, -- flag to denote the vehicle has a modified plate
    ["omni_plate_hash"] = {DECOR.INT, "Custom Plate Hash"}, -- hashed version of plate for validation

    -- User Data
    ["omni_user_id"] = {DECOR.INT, "User ID"}, -- user id of the entity owner

    -- Fuel Control
    ["omni_fuel_value"] = {DECOR.FLOAT, "Fuel"}, -- the amount of fuel in the vehicle
    ["omni_fuel_disabled"] = {DECOR.BOOL, "Has Fuel Disabled"}, -- disable the fuel system for the vehicle

    -- Generic Vehicle Decorators
    ["omni_delete_upon_exit"] = {DECOR.BOOL, "Delete Upon Exit"}, -- delete the vehicle once the player leaves the driver seat
    ["omni_speed_boost"] = {DECOR.FLOAT, "Speed Boost Modifier"}, -- speed boost modifier
    ["omni_spawn_time"] = {DECOR.TIME, "Spawn Timestamp"}, -- timestamp when the vehicle was spawned
    ["omni_last_use"] = {DECOR.TIME, "Last Used Timestamp"}, -- last time the vehicle was in use
    ["omni_owner_id"] = {DECOR.INT, "Owner User ID"}, -- the vrp id of the player who spawned the vehicle
    ["omni_owner_cid"] = {DECOR.INT, "Owner Server ID"}, -- the server id of the player who spawned the vehicle
    ["omni_admin_spawned"] = {DECOR.BOOL, "Staff Vehicle"}, -- if the vehicle was spawned by staff
    ["omni_script_spawned"] = {DECOR.BOOL, "Script Vehicle"}, -- if the vehicle was spawned by script
    ["omni_voucher_spawned"] = {DECOR.BOOL, "Voucher Vehicle"}, -- if the vehicle was spawned via a voucher / card
    ["locked"] = {DECOR.BOOL, "Locked"}, -- prevent a player from entering the vehicle
    ["aircontrols"] = {DECOR.BOOL, "Air Controls"}, -- enable air controls

    ["mass"] = {DECOR.FLOAT, "Mass"}, -- used for weight calculations (increased by trunk use)

    -- Vehicle Restrictions
    ["omni_admin_only"] = {DECOR.BOOL, "Admin Only"}, -- non-staff can not use the vehicle
    ["omni_no_seatbelt"] = {DECOR.BOOL, "No Seatbelt"}, -- seatbelt mechanic is disabled in the vehicle
    ["omni_no_racing"] = {DECOR.BOOL, "No Racing"}, -- prevent the vehicle from being used in races

    -- Special Vehicle Properties
    ["omni_ignore_locker"] = {DECOR.BOOL, "Ignore Locker"}, -- allow use even if player doesn't meet requirements
    ["omni_can_delete"] = {DECOR.BOOL, "Can Delete"}, -- allow zDelete on the vehicle (?)
    ["omni_norepmod"] = {DECOR.BOOL, "No Repair"}, -- prevent repairing the vehicle
    ["omni_nocleanup"] = {DECOR.BOOL, "No Cleanup"}, -- prevent automatic cleanup of the vehicle

    -- Emergency Siren Control
    ["esc_siren_enabled"] = {DECOR.BOOL, "Siren Toggle"}, -- siren enabled (when false the lights can be on without the siren)

    -- Player Blip
    ["sprite_override"] = {DECOR.INT, "Sprite Override"}, -- override player blip sprite
    ["omni_blip_hidden"] = {DECOR.BOOL, "Hidden Blip"}, -- prevent the player blip from appearing
}

local decorFunctions = {
    [DECOR.FLOAT] = function(propertyName, entity, fn)
        local val = DecorGetFloat(entity, propertyName)
        fn(val)
    end,
    [DECOR.BOOL] = function(propertyName, entity, fn)
        local val = DecorGetBool(entity, propertyName)
        fn(val)
    end,
    [DECOR.INT] = function(propertyName, entity, fn)
        local val = DecorGetInt(entity, propertyName)
        fn(val)
    end,
    [DECOR.UNK] = function(propertyName, entity, fn)
        local val = DecorGetInt(entity, propertyName)
        fn(val)
    end,
    [DECOR.TIME] = function(propertyName, entity, fn)
        local val = DecorGetInt(entity, propertyName)
        fn(val)
    end,
}

return {getter = decorFunctions, decorators = DECORATORS}
