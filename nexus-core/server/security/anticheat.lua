local AntiCheat = {
    flaggedPlayers = {}
}

function AntiCheat.FlagPlayer(playerId, reason)
    local player = NexusCore.Players.Get(playerId)
    if not player then return end
    
    AntiCheat.flaggedPlayers[playerId] = (AntiCheat.flaggedPlayers[playerId] or 0) + 1
    
    if AntiCheat.flaggedPlayers[playerId] >= 3 then
        NexusCore.Admin.BanPlayer(0, playerId, 'Anti-Cheat Violation: '..reason, 7 * 24 * 60 * 60)
    else
        NexusCore.Admin.KickPlayer(0, playerId, 'Suspicious activity detected')
    end
end

RegisterNetEvent('nexus:security:flag')
AddEventHandler('nexus:security:flag', function(reason)
    AntiCheat.FlagPlayer(source, reason)
end)

return AntiCheat