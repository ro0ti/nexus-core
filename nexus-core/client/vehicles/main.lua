local Vehicle = {
    CurrentVehicle = nil,
    SpawnQueue = {},
    IsSpawning = false,
    ResourceName = GetCurrentResourceName()
}

-- Model loading with timeout
function Vehicle.LoadModel(modelHash)
    if not IsModelInCdimage(modelHash) then
        return false, "invalid_model"
    end
    
    RequestModel(modelHash)
    
    local startTime = GetGameTimer()
    local timeout = 10000 -- 10 seconds
    
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() - startTime > timeout then
            return false, "timeout"
        end
        Citizen.Wait(0)
    end
    
    return true
end

-- Safe vehicle creation
function Vehicle.CreateVehicle(data)
    if not data or not data.model then
        return false, "invalid_data"
    end
    
    local modelHash = type(data.model) == "string" and GetHashKey(data.model) or data.model
    local success, err = Vehicle.LoadModel(modelHash)
    
    if not success then
        return false, err
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, true, false)
    if not DoesEntityExist(vehicle) then
        return false, "creation_failed"
    end
    
    -- Apply vehicle properties
    if data.plate then
        SetVehicleNumberPlateText(vehicle, data.plate)
    end
    
    if data.mods and type(data.mods) == "table" then
        NexusCore.Vehicles.ApplyMods(vehicle, data.mods)
    end
    
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    SetModelAsNoLongerNeeded(modelHash)
    
    Vehicle.CurrentVehicle = vehicle
    return true, vehicle
end

-- Process spawn queue
function Vehicle.ProcessQueue()
    if Vehicle.IsSpawning or #Vehicle.SpawnQueue == 0 then
        return
    end
    
    Vehicle.IsSpawning = true
    local nextVehicle = table.remove(Vehicle.SpawnQueue, 1)
    
    local success, result = Vehicle.CreateVehicle(nextVehicle)
    if not success then
        print(("[%s] Vehicle spawn failed: %s"):format(
            Vehicle.ResourceName,
            result
        ))
        NexusCore.UI.ShowNotification("Failed to spawn vehicle")
    end
    
    Vehicle.IsSpawning = false
    
    -- Process next in queue
    if #Vehicle.SpawnQueue > 0 then
        Vehicle.ProcessQueue()
    end
end

-- Event handler
RegisterNetEvent("nexus:vehicles:spawn", function(data)
    if not data or type(data) ~= "table" then
        return
    end
    
    -- Validate required fields
    if not data.model then
        return
    end
    
    -- Add to queue
    table.insert(Vehicle.SpawnQueue, data)
    
    -- Start processing if not already
    if not Vehicle.IsSpawning then
        Vehicle.ProcessQueue()
    end
end)

-- Cleanup
AddEventHandler("onResourceStop", function(resource)
    if resource == Vehicle.ResourceName and Vehicle.CurrentVehicle then
        if DoesEntityExist(Vehicle.CurrentVehicle) then
            DeleteEntity(Vehicle.CurrentVehicle)
        end
    end
end)