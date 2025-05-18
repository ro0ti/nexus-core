local Vehicles = {
    PlayerVehicles = {},
    CacheTime = 5 * 60 * 1000, -- 5 minutes
    ResourceName = GetCurrentResourceName()
}

-- Get player vehicles with caching
function Vehicles.GetPlayerVehicles(playerId)
    if type(playerId) ~= "number" then
        error("Invalid player ID")
    end
    
    local player = NexusCore.Players.Get(playerId)
    if not player then
        return {}
    end
    
    -- Check cache
    local cache = Vehicles.PlayerVehicles[playerId]
    if cache and (GetGameTimer() - cache.timestamp) < Vehicles.CacheTime then
        return cache.vehicles
    end
    
    -- Query database
    local result, err = MySQL.query.await(
        "SELECT * FROM player_vehicles WHERE citizenid = ?",
        { player.citizenid }
    )
    
    if not result then
        print(("[%s] Vehicles query error: %s"):format(
            Vehicles.ResourceName,
            err
        ))
        return {}
    end
    
    -- Validate and clean vehicle data
    local cleanedVehicles = {}
    for _, vehicle in ipairs(result) do
        if vehicle.model and vehicle.plate then
            -- Clean mods data
            local mods = {}
            if vehicle.mods then
                local success, decoded = pcall(json.decode, vehicle.mods)
                if success and type(decoded) == "table" then
                    mods = decoded
                end
            end
            
            table.insert(cleanedVehicles, {
                id = vehicle.id,
                model = vehicle.model,
                plate = vehicle.plate,
                mods = mods
            })
        end
    end
    
    -- Update cache
    Vehicles.PlayerVehicles[playerId] = {
        vehicles = cleanedVehicles,
        timestamp = GetGameTimer()
    }
    
    return cleanedVehicles
end

-- Spawn vehicle handler
function Vehicles.SpawnVehicle(playerId, vehicleId)
    if type(vehicleId) ~= "number" then
        return false
    end
    
    local vehicles = Vehicles.GetPlayerVehicles(playerId)
    for _, vehicle in ipairs(vehicles) do
        if vehicle.id == vehicleId then
            -- Validate vehicle data
            if not vehicle.model or not vehicle.plate then
                return false
            end
            
            -- Prepare clean data for client
            local spawnData = {
                model = vehicle.model,
                plate = vehicle.plate,
                mods = vehicle.mods or {}
            }
            
            TriggerClientEvent("nexus:vehicles:spawn", playerId, spawnData)
            return true
        end
    end
    
    return false
end

-- Event handler
RegisterNetEvent("nexus:vehicles:requestSpawn", function(vehicleId)
    local playerId = source
    
    if type(vehicleId) ~= "number" then
        return
    end
    
    local status, result = pcall(Vehicles.SpawnVehicle, playerId, vehicleId)
    if not status then
        print(("[%s] Spawn error: %s"):format(
            Vehicles.ResourceName,
            result
        ))
    elseif not result then
        TriggerClientEvent("nexus:notification", playerId, "Vehicle not found")
    end
end)

-- Cache cleanup
CreateThread(function()
    while true do
        Citizen.Wait(Vehicles.CacheTime)
        
        local currentTime = GetGameTimer()
        for playerId, cache in pairs(Vehicles.PlayerVehicles) do
            if (currentTime - cache.timestamp) >= Vehicles.CacheTime then
                Vehicles.PlayerVehicles[playerId] = nil
            end
        end
    end
end)