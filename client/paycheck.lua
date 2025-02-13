vRP = Proxy.getInterface("vRP")

-- Citizen.CreateThread(function ()
-- 	while true do
-- 	local user_id = vRP.getUserId(source)
-- 		Citizen.Wait(300000) -- Every X ms you'll get paid (300000 = 5 min)
-- 		TriggerServerEvent('omni_welfare:salary')
-- 	end
-- end)
--[[
Citizen.CreateThread(function ()
	while true do
	local user_id = vRP.getUserId(source)
		Citizen.Wait(600000) -- Every X ms you'll get paid (300000 = 5 min)
		TriggerServerEvent('paycheck:bonus')
	end
end)

local user_id = vRP.getUserId(source)
if vRP.tryGetInventoryItem(user_id,"booster_common",1) then
	TriggerServerEvent("booster_common:pack:server")
end]]
