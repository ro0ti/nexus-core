local Garages = {
    _garages = {},
    _playerGarages = {}
}

-- Load garages from database
function Garages.LoadGarages()
    local result = MySQL.query.await('SELECT * FROM garages')
    for _, garage in ipairs(result) do
        Garages._garages[garage.name] = garage
    end
end

-- Get player garage vehicles
function Garages.GetPlayerVehicles(playerId, garageName)
    if not Garages._playerGarages[playerId] then
        Garages._playerGarages[playerId] = {}
    end
    
    if not Garages._playerGarages[playerId][garageName] then
        local result = MySQL.query.await(
            'SELECT * FROM player_vehicles WHERE owner = ? AND garage = ?',
            {playerId, garageName}
        )
        Garages._playerGarages[playerId][garageName] = result
    end
    
    return Garages._playerGarages[playerId][garageName]
end

-- Store vehicle in garage
function Garages.StoreVehicle(playerId, garageName, vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if not DoesEntityExist(vehicle) then return false end
    
    local playerVehicles = Garages.GetPlayerVehicles(playerId, garageName)
    local vehicleProps = GetVehicleProperties(vehicle)
    
    -- Find matching vehicle
    for _, v in ipairs(playerVehicles) do
        if v.plate == vehicleProps.plate then
            -- Update vehicle data
            MySQL.update.await(
                'UPDATE player_vehicles SET vehicle_props = ?, garage = ? WHERE id = ?',
                {json.encode(vehicleProps), garageName, v.id}
            )
            
            -- Despawn vehicle
            DeleteEntity(vehicle)
            return true
        end
    end
    
    return false
end

return Garages