local Character = {
    ResourceName = GetCurrentResourceName()
}

function Character.Create(playerId, data)
    local player = NexusCore.Players.Get(playerId)
    if not player then
        return false, "invalid_player"
    end

    -- Validate data
    if not data or type(data) ~= 'table' then
        return false, "invalid_data"
    end

    -- Check if player already has a character
    local existing = MySQL.scalar.await(
        'SELECT 1 FROM characters WHERE license = ?',
        {GetPlayerIdentifier(playerId, 0)}
    )
    
    if existing then
        return false, "character_exists"
    end

    -- Insert new character
    local success, err = MySQL.insert.await(
        'INSERT INTO characters (license, firstname, lastname, gender, dob, appearance) VALUES (?, ?, ?, ?, ?, ?)',
        {
            GetPlayerIdentifier(playerId, 0),
            data.firstname,
            data.lastname,
            data.gender,
            data.dob,
            json.encode(data.appearance or {})
        }
    )

    if not success then
        return false, "database_error"
    end

    -- Update player metadata
    NexusCore.Players.SetMeta(playerId, 'character', {
        firstname = data.firstname,
        lastname = data.lastname
    })

    return true
end

-- Event Handlers
RegisterNetEvent('nexus:character:create', function(data)
    local success, err = Character.Create(source, data)
    if not success then
        NexusCore.UI.ShowNotification(source, 'Character creation failed: '..(err or 'unknown error'))
    end
end)

-- Exports
exports('GetCharacter', function(playerId)
    return MySQL.query.await(
        'SELECT * FROM characters WHERE license = ?',
        {GetPlayerIdentifier(playerId, 0)}
    )[1]
end)