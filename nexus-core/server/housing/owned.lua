local Housing = {}

function Housing.GetPlayerHouses(playerId)
    local result = MySQL.query.await('SELECT * FROM player_houses WHERE owner = ?', {playerId})
    return result
end

function Housing.SetHouseOwner(houseId, playerId)
    MySQL.update.await('UPDATE player_houses SET owner = ? WHERE id = ?', {playerId, houseId})
    return true
end

RegisterNetEvent('nexus:housing:enter')
AddEventHandler('nexus:housing:enter', function(houseId)
    local src = source
    local player = NexusCore.Players.Get(src)
    
    local result = MySQL.query.await('SELECT * FROM houses WHERE id = ?', {houseId})
    if result[1] then
        local house = result[1]
        if house.owner == player.citizenid or house.owner == '' then
            TriggerClientEvent('nexus:housing:entered', src, houseId, json.decode(house.interior))
        end
    end
end)

return Housing