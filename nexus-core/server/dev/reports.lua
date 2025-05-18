local Reports = {}

function Reports.SaveReport(playerId, message)
    MySQL.insert.await('INSERT INTO reports (player_id, message) VALUES (?, ?)', {
        playerId, message
    })
end

RegisterNetEvent('nexus:dev:submitReport')
AddEventHandler('nexus:dev:submitReport', function(message)
    Reports.SaveReport(source, message)
end)

RegisterNetEvent('nexus:dev:setDebug')
AddEventHandler('nexus:dev:setDebug', function(state)
    local player = NexusCore.Players.Get(source)
    if player and player.group == 'admin' then
        Config.DebugMode = state
    end
end)

return Reports