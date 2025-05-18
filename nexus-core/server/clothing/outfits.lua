local Outfits = {}

function Outfits.SaveOutfit(playerId, name, data)
    local player = NexusCore.Players.Get(playerId)
    if not player then return false end
    
    local outfits = Outfits.GetPlayerOutfits(playerId)
    outfits[name] = data
    
    MySQL.update.await('UPDATE players SET outfits = ? WHERE id = ?', {
        json.encode(outfits), playerId
    })
    return true
end

function Outfits.GetPlayerOutfits(playerId)
    local result = MySQL.query.await('SELECT outfits FROM players WHERE id = ?', {playerId})
    return json.decode(result[1].outfits) or {}
end

RegisterNetEvent('nexus:clothing:saveOutfit')
AddEventHandler('nexus:clothing:saveOutfit', function(name, data)
    Outfits.SaveOutfit(source, name, data)
end)

return Outfits