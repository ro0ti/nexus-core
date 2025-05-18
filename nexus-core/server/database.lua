local Database = {
    _connection = nil,
    _prepared = {},
    _cache = {}
}

-- Connect to database
function Database.Connect(config)
    MySQL.ready(function()
        Database._connection = true
        print("[Database] Connection established")
        
        -- Prepare statements
        Database._prepareStatements()
    end)
end

-- Prepare common statements
function Database._prepareStatements()
    Database._prepared['get_player'] = MySQL.prepare.await(
        "SELECT * FROM players WHERE license = ?",
        {"string"}
    )
    
    Database._prepared['is_banned'] = MySQL.prepare.await(
        "SELECT 1 FROM bans WHERE license = ? AND (expire > NOW() OR expire IS NULL)",
        {"string"}
    )
end

-- Check if player is banned
function Database.IsBanned(license)
    local result = Database._prepared['is_banned'](license)
    return result and true or false
end

-- Get player data
function Database.GetPlayerData(license)
    return Database._prepared['get_player'](license)
end

-- Save player data
function Database.SavePlayerData(player)
    -- Implementation would save player data to database
    -- This is a placeholder for the example
    print(("[Database] Saving data for player %s"):format(player.license))
end

return Database