statCfg = module("cfg/stats")

local hasReceivedStats = false
Citizen.CreateThread(function()
    while true do
        Wait(120000)
        if not hasReceivedStats then

        else
            local stats = {}
            for STAT, statData in next, statCfg.native do
                if statData[1] == "int" then
                    local exists, VALUE = StatGetInt(STAT, -1)
                    stats[STAT] = VALUE
                elseif statData[1] == "float" then
                    local exists, VALUE = StatGetFloat(STAT, -1)
                    stats[STAT] = VALUE
                else
                    tvRP.log("Stat type " .. statData[1] .. " is not being handled")
                end
            end
            vRPserver.updateStats({stats})
        end
    end
end)

function tvRP.initializeStats(stats)
    if not hasReceivedStats then
        for STAT, VALUE in next, stats do
            if statCfg.native[STAT] then
                local statData = statCfg.native[STAT]
                -- cfg["HIGHEST_SKITTLES"] = {TYPE.INT, "Number of Peds Run down"}
                if statData[1] == "int" then
                    StatSetInt(STAT, math.floor(VALUE), true)
                elseif statData[1] == "float" then
                    StatSetFloat(STAT, VALUE, true)
                else
                    tvRP.log("Stat type " .. statData[1] .. " is not being handled")
                end
            else
                tvRP.log("Stat " .. STAT .. " is not being monitored")
            end
        end
        hasReceivedStats = true
        tvRP.log("Received stats")
    end
end
