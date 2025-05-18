local Players = {
    _players = {},
    _cachedPlayers = {}
}

-- Secure player retrieval
function Players.Get(source, safeMode)
    if not source then return nil end
    
    if Players._cachedPlayers[source] then
        return Players._cachedPlayers[source]
    end

    local player = {
        source = source,
        charId = nil,
        license = GetPlayerIdentifierByType(source, 'license2') or GetPlayerIdentifierByType(source, 'license'),
        name = GetPlayerName(source),
        groups = {'user'},
        vars = {},
        lastAccessed = os.time()
    }

    if safeMode then
        if not player.license then
            DropPlayer(source, "Invalid player identification")
            return nil
        end
        
        if NexusCore.Database.IsBanned(player.license) then
            DropPlayer(source, "You are banned from this server")
            return nil
        end
    end

    Players._players[source] = player
    Players._cachedPlayers[source] = player

    return player
end

-- Remove disconnected players
function Players.Remove(source)
    if Players._players[source] then
        NexusCore.Database.SavePlayerData(Players._players[source])
        Players._players[source] = nil
        Players._cachedPlayers[source] = nil
    end
end

-- Add player variable
function Players.SetVar(source, key, value)
    local player = Players.Get(source)
    if player then
        player.vars[key] = value
    end
end

-- Get player variable
function Players.GetVar(source, key)
    local player = Players.Get(source)
    return player and player.vars[key]
end

return Players