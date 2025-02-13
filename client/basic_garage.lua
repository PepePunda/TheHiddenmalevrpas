local vehicles = {}
AddEventHandler('vrp_garages:setVehicle', function(vtype, vehicle)
	vehicles[vtype] = vehicle
end)
function GetPlayerVehicle(vtype)
    if vehicles[vtype] then
        local vehicle = vehicles[vtype]
        if NetworkDoesEntityExistWithNetworkId(vehicle[4]) then
        	local newVehicle = NetworkGetEntityFromNetworkId(vehicle[4])
			if GetEntityModel(newVehicle) == vehicle[6] then
                vehicle[3] = newVehicle
			end
        end
        return vehicle
    end
    return nil
end

exports('getOwnedVehicles', function()
	return vehicles
end)
-- vehicles[vtype] = {vtype, name, vehicleID, networkId}


AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, name)
	for vtype, _ in next, vehicles do
		local vehicle = GetPlayerVehicle(vtype)
		if vehicle[3] == currentVehicle then
			tvRP.onOwnedVehicleEntered(vtype)
		else
			tvRP.onOwnedVehicleCheatedOn(vtype)
		end
	end
end)

AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, name)
	for vtype, _ in next, vehicles do
		local vehicle = GetPlayerVehicle(vtype)
		if vehicle[3] == currentVehicle then
			tvRP.onOwnedVehicleLeft(vtype)
		end
	end
end)

function tvRP.onOwnedVehicleEntered(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle then
		local blip = GetBlipFromEntity(vehicle[3])
		if DoesBlipExist(blip) then
			SetBlipAlpha(blip, 0)
		end
	end
end

function tvRP.onOwnedVehicleLeft(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle then
		local blip = GetBlipFromEntity(vehicle[3])
		if DoesBlipExist(blip) then
			SetBlipAlpha(blip, 255)
		end
	end
end

function tvRP.onOwnedVehicleCheatedOn(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle then
		local blip = GetBlipFromEntity(vehicle[3])
		if DoesBlipExist(blip) then
			SetBlipAlpha(blip, 255)
		end
	end
end

function tvRP.updateOwnedVehicle(vtype, used, capacity)
	local percentage = (100 / capacity) * used
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle then
		local vehicleEntity = vehicle[3]
		if DoesEntityExist(vehicleEntity) then
			TriggerEvent("trucking-cargo:SetVehicleProps", vehicleEntity, percentage, used)
		end
	end
end

--function tvRP.spawnGarageVehicle(vtype,name) -- vtype is the vehicle type (one vehicle per type allowed at the same time)
function tvRP.spawnGarageVehicle(vtype,name,pos) -- vtype is the vehicle type (one vehicle per type allowed at the same time)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
		-- despawn vehicle
		SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
		Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
		SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
		TriggerEvent("vrp_garages:setVehicle", vtype, nil)
	end

	vehicle = GetPlayerVehicle(vtype)
	if vehicle == nil then
		-- load vehicle model
		local mhash = GetHashKey(name)

		local i = 0
		while not HasModelLoaded(mhash) and i < 10000 do
			RequestModel(mhash)
			Citizen.Wait(10)
			i = i+1
		end

		-- spawn car
		if HasModelLoaded(mhash) then
			local x,y,z = tvRP.getPosition()
			if pos then
				x,y,z = table.unpack(pos)
			end
			local nveh = CreateVehicle(mhash, x,y,z+0.5, 0.0, true, false)
			SetVehicleOnGroundProperly(nveh)
			SetEntityInvincible(nveh,false)
			SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside
			SetVehicleNumberPlateText(nveh, "P "..tvRP.getRegistrationNumber())
			Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
			SetVehicleHasBeenOwnedByPlayer(nveh,true)

			local nid = NetworkGetNetworkIdFromEntity(nveh)
			if not cfg.vehicle_migration then
				SetNetworkIdCanMigrate(nid,false)
			end

			vehicles[vtype] = {vtype,name,nveh,nid} -- set current vehicule
			local gas = math.random (30,70)
			TriggerEvent("advancedFuel:setEssence", gas, "P "..tvRP.getRegistrationNumber(), name)
			SetModelAsNoLongerNeeded(mhash)
		end
	else
		tvRP.notify("You can only have one "..vtype.." vehicle out.")
	end
end

-- check vehicles validity
--[[
Citizen.CreateThread(function()
Citizen.Wait(30000)

for k,v in pairs(vehicles) do
if IsEntityAVehicle(v[3]) then -- valid, save position
v.pos = {table.unpack(GetEntityCoords(vehicle[3],true))}
elseif v.pos then -- not valid, respawn if with a valid position
tvRP.log("[vRP] invalid vehicle "..v[1]..", respawning...")
tvRP.spawnGarageVehicle(v[1], v[2], v.pos)
end
end
end)
--]]


function tvRP.despawnGarageVehicle(vtype,max_range)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle then
		local x,y,z = table.unpack(GetEntityCoords(vehicle[3],true))
		local px,py,pz = tvRP.getPosition()

		if #(vec3(x, y, z) - vec3(px, py, pz)) < max_range then -- check distance with the vehicule
			-- remove vehicle
			SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
			Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
			SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
			TriggerEvent("vrp_garages:setVehicle", vtype, nil)
			tvRP.notify("Vehicle stored.")
		else
			tvRP.notify("Too far away from the vehicle.")
		end
	end
end

function tvRP.getOwnedVehicleNetId(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle then
		local net = vehicle[4]
		return true, net
	end
	return false, 0
end

function tvRP.isPlayerInOwnedVehicle()
	local b, veh = tvRP.getVehiclePedIsIn()
	if b then
		for k, v in pairs(vehicles) do
			if v[3] == veh then
				return true, v
			end
		end
	end
	return false, {}
end

function tvRP.wasPlayerInOwnedVehicle()
	local veh = tvRP.getVehiclePedWasIn()
	if veh then
		for k, v in pairs(vehicles) do
			if v[3] == veh then
				return true, v
			end
		end
	end
	return false, {}
end

function tvRP.getVehiclePedWasIn()
	local ped = GetPlayerPed(-1)
	return GetVehiclePedIsIn(ped, true)
end

function tvRP.getVehiclePedIsIn()
	local ped = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ped) then
		return true, GetVehiclePedIsIn(ped, true), (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, true), -1) == ped)
	end
	return false, 0, false
end

-- (experimental) this function return the nearest vehicle
-- (don't work with all vehicles, but aim to)
function tvRP.getNearestVehicle(radius)
	local x,y,z = tvRP.getPosition()
	local ped = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ped) then
		return GetVehiclePedIsIn(ped, true)
	else
		-- flags used:
		--- 8192: boat
		--- 4096: helicos
		--- 4,2,1: cars (with police)

		local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
		if not IsEntityAVehicle(veh) then
			veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1)
		end -- cars
		return veh
	end
end

function tvRP.fixeNearestVehicle(radius)
	local veh = tvRP.getNearestVehicle(radius)
	local healthChange = 0
	-- print("REPAIR 1")
	if IsEntityAVehicle(veh) then
		-- print("REPAIR 2")
		local vehicleHealth = GetVehicleBodyHealth(veh) + GetVehicleEngineHealth(veh)
		SetVehicleFixed(veh)
		SetVehicleBodyHealth(veh, 1000.0)
		SetVehicleEngineHealth(veh, 1000.0)
		-- print("REPAIR 3")
		healthChange = healthChange + (GetVehicleBodyHealth(veh) + GetVehicleEngineHealth(veh)) - vehicleHealth
	end
	-- print("REPAIR 4: " .. healthChange)
	return healthChange
end

function tvRP.replaceNearestVehicle(radius)
	local veh = tvRP.getNearestVehicle(radius)
	if IsEntityAVehicle(veh) then
		SetVehicleOnGroundProperly(veh)
	end
end

-- try to get a vehicle at a specific position (using raycast)
function tvRP.getVehicleAtPosition(x,y,z)
	x = x+0.0001
	y = y+0.0001
	z = z+0.0001

	local ray = CastRayPointToPoint(x,y,z,x,y,z+4,10,GetPlayerPed(-1),0)
	local a, b, c, d, ent = GetRaycastResult(ray)
	return ent
end

function GetVehicleVisualName(vname)
	local showName = GetLabelText(GetDisplayNameFromVehicleModel(vname))
	if showName == "NULL" or showName == nil then
		showName = vname
	else
		showName = showName .. " (" .. vname .. ")"
	end
	return showName
end

function tvRP.kickFromVehicle(net, player, mod)
	local veh = NetToVeh(net)
	local kickPass = (mod == -1 or mod == 1)
	local kickDriver = (mod == 0 or mod == 1)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then
		if GetVehiclePedIsIn(ped, false) == veh then
			local isDriver = GetPedInVehicleSeat(veh, -1) == ped
			if (isDriver and kickDriver) or ((not isDriver) and kickPass) then
				TaskLeaveAnyVehicle(ped, true, true)
			end
		end
	end
end

-- return ok,vtype,name
function tvRP.getNearestOwnedVehicle(radius, priority)
	local px,py,pz = tvRP.getPosition()
	local vehs = {}
	for k,v in pairs(vehicles) do
		local x,y,z = table.unpack(GetEntityCoords(v[3],true))
		local dist = #(vec3(x, y, z) - vec3(px, py, pz))
		if dist <= radius+0.0001 and IsVehicleDriveable(v[3]) then
			table.insert(vehs, {dist,v})
		end
	end
	if #vehs > 0 then
		table.sort(vehs, function(a,b) return a[1] < b[1] end)
		if priority then
			table.sort(vehs, function(a,b) if a[2][1] == priority then return true elseif b[2][1] == priority then return false else return a[1] < b[1] end end)
		end
		return true,vehs[1][2][1],vehs[1][2][2],GetVehicleVisualName(vehs[1][2][2])
	end

	return false,"","",""
end

function tvRP.getNearbyOwnedVehicles(radius)
	local px,py,pz = tvRP.getPosition()
	local ret = {}
	local ok = false
	for k,v in pairs(vehicles) do
		local x,y,z = table.unpack(GetEntityCoords(v[3],true))
		local dist = #(vec3(x, y, z) - vec3(px, py, pz))
		if dist <= radius+0.0001 and IsVehicleDriveable(v[3]) then
			table.insert(ret, {v[1],v[2],GetVehicleVisualName(v[2]),dist})
			ok = true
		end
	end
	return ok, ret
end

-- return ok,x,y,z
function tvRP.getAnyOwnedVehiclePosition()
	for k,v in pairs(vehicles) do
		if IsEntityAVehicle(v[3]) and IsVehicleDriveable(v[3]) then
			local x,y,z = table.unpack(GetEntityCoords(v[3],true))
			return true,x,y,z
		end
	end

	return false,0,0,0
end

-- return x,y,z
function tvRP.getOwnedVehiclePosition(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	local x,y,z = 0,0,0

	if vehicle and IsVehicleDriveable(vehicle[3]) then
		x,y,z = table.unpack(GetEntityCoords(vehicle[3],true))
	end

	return x,y,z
end

-- return ok, vehicule network id
function tvRP.getOwnedVehicleId(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		return true, NetworkGetNetworkIdFromEntity(vehicle[3])
	else
		return false, 0
	end
end

-- eject the ped from the vehicle
function tvRP.ejectVehicle()
	local ped = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ped) then
		local veh = GetVehiclePedIsIn(ped,false)
		TaskLeaveVehicle(ped, veh, 4160)
	end
end

-- vehicle commands
function tvRP.vc_openDoor(vtype, door_index)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		SetVehicleDoorOpen(vehicle[3],door_index,0,false)
	end
end

function tvRP.vc_closeDoor(vtype, door_index)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		SetVehicleDoorShut(vehicle[3],door_index,true)
	end
end

function tvRP.vc_detachTrailer(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		DetachVehicleFromTrailer(vehicle[3])
	end
end

function tvRP.vc_detachTowTruck(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		local ent = GetEntityAttachedToTowTruck(vehicle[3])
		if IsEntityAVehicle(ent) then
			DetachVehicleFromTowTruck(vehicle[3],ent)
		end
	end
end

function tvRP.vc_detachCargobob(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		local ent = GetVehicleAttachedToCargobob(vehicle[3])
		if IsEntityAVehicle(ent) then
			DetachVehicleFromCargobob(vehicle[3],ent)
		end
	end
end

function tvRP.vc_toggleEngine(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle[3]) -- GetIsVehicleEngineRunning
		SetVehicleEngineOn(vehicle[3],not running,true,true)
		if running then
			SetVehicleUndriveable(vehicle[3],true)
		else
			SetVehicleUndriveable(vehicle[3],false)
		end
	end
end

function tvRP.vc_apark(vtype)
	TriggerEvent("es:deleteVehicle")
end

function tvRP.vc_toggleLock(vtype)
	local vehicle = GetPlayerVehicle(vtype)
	RequestAnimDict("anim@mp_player_intmenu@key_fob@")
	while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
		Citizen.Wait(100)
	end
	if vehicle and IsVehicleDriveable(vehicle[3]) then
		local veh = vehicle[3]
		local locked = DecorExistOn(veh, "locked") and DecorGetBool(veh, "locked")
		if locked then -- unlock
			DecorSetBool(veh, "locked", false)
			SetVehicleDoorsLocked(veh,1)
			SetVehicleDoorsLockedForAllPlayers(veh, false)
			SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
			TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, -8.0, -1, 48, 0, 0, 0, 0)
			SetEntityLights(veh, 0)
			SoundVehicleHornThisFrame(veh)
			SetVehicleIndicatorLights(veh, 1, 1)
			SetVehicleIndicatorLights(veh, 0, 1)
			Wait(700)
			SetVehicleIndicatorLights(veh, 1, 0)
			SetVehicleIndicatorLights(veh, 0, 0)
			SetEntityLights(veh, 1)
			PlaySoundFromEntity(-1, "unlocked_bleep", veh, "HACKING_DOOR_UNLOCK_SOUNDS", 0, 0)
			tvRP.notify("Vehicle unlocked.")
		else -- lock
			DecorSetBool(veh, "locked", true)
			SetVehicleDoorsLocked(veh,1)
			SetVehicleDoorsLockedForAllPlayers(veh, true)
			SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
			TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, -8.0, -1, 48, 0, 0, 0, 0)
			SetEntityLights(veh, 0)
			SoundVehicleHornThisFrame(veh)
			SetVehicleIndicatorLights(veh, 1, 1)
			SetVehicleIndicatorLights(veh, 0, 1)
			Wait(700)
			SetVehicleIndicatorLights(veh, 1, 0)
			SetVehicleIndicatorLights(veh, 0, 0)
			SetEntityLights(veh, 1)
			PlaySoundFromEntity(-1, "unlocked_bleep", veh, "HACKING_DOOR_UNLOCK_SOUNDS", 0, 0)
			tvRP.notify("Vehicle locked.")
		end
	end
end
