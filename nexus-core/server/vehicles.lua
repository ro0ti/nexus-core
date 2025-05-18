local Vehicles = {
    _spawnedVehicles = {},
    _ownedVehicles = {}
}

-- Load player vehicles from database
function Vehicles.LoadPlayerVehicles(playerId)
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE owner = ?', {playerId})
    Vehicles._ownedVehicles[playerId] = result
    return result
end

-- Spawn player vehicle
function Vehicles.SpawnVehicle(playerId, vehicleId)
    local vehicles = Vehicles._ownedVehicles[playerId]
    if not vehicles then return false end
    
    local vehicleData
    for _, v in ipairs(vehicles) do
        if v.id == vehicleId then
            vehicleData = v
            break
        end
    end
    
    if not vehicleData then return false end
    
    -- Despawn existing vehicle if any
    if Vehicles._spawnedVehicles[playerId] then
        Vehicles.DespawnVehicle(playerId)
    end
    
    -- Spawn new vehicle
    local player = NexusCore.Players.Get(playerId)
    local coords = GetEntityCoords(GetPlayerPed(playerId))
    
    local vehicle = CreateVehicle(
        joaat(vehicleData.vehicle),
        coords.x, coords.y, coords.z,
        GetEntityHeading(GetPlayerPed(playerId)),
        true,
        false
    )
    
    Vehicles._spawnedVehicles[playerId] = {
        netId = NetworkGetNetworkIdFromEntity(vehicle),
        vehicleData = vehicleData
    }
    
    return true
end

-- Despawn player vehicle
function Vehicles.DespawnVehicle(playerId)
    if Vehicles._spawnedVehicles[playerId] then
        local vehicle = NetworkGetEntityFromNetworkId(Vehicles._spawnedVehicles[playerId].netId)
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
        Vehicles._spawnedVehicles[playerId] = nil
        return true
    end
    return false
end

-- Purchase vehicle
function Vehicles.PurchaseVehicle(playerId, vehicleModel, garage)
    local player = NexusCore.Players.Get(playerId)
    if not player then return false end
    
    local vehiclePrice = NexusCore.Config.Vehicles[vehicleModel]?.price
    if not vehiclePrice then return false end
    
    if not NexusCore.RemoveMoney(playerId, 'bank', vehiclePrice) then
        return false
    end
    
    local result = MySQL.insert.await(
        'INSERT INTO player_vehicles (owner, vehicle, plate, garage) VALUES (?, ?, ?, ?)',
        {playerId, vehicleModel, GeneratePlate(), garage}
    )
    
    if result then
        Vehicles.LoadPlayerVehicles(playerId)
        return true
    end
    
    -- Refund if failed
    NexusCore.AddMoney(playerId, 'bank', vehiclePrice)
    return false
end

return Vehicles