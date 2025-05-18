local Vehicle = {
    _currentVehicle = nil,
    _ownedVehicles = {}
}

-- Spawn vehicle
function Vehicle.Spawn(vehicleId)
    NexusCore.TriggerServerCallback('nexus:server:spawnVehicle', function(netId)
        if netId then
            local vehicle = NetworkGetEntityFromNetworkId(netId)
            Vehicle._currentVehicle = vehicle
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end
    end, vehicleId)
end

-- Despawn current vehicle
function Vehicle.Despawn()
    if not Vehicle._currentVehicle then return end
    
    NexusCore.TriggerServerCallback('nexus:server:despawnVehicle', function(success)
        if success then
            Vehicle._currentVehicle = nil
        end
    end)
end

-- Get vehicle properties
function Vehicle.GetProperties(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local color1, color2 = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    
    return {
        model = GetEntityModel(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        color1 = color1,
        color2 = color2,
        pearlescentColor = pearlescentColor,
        wheelColor = wheelColor,
        -- Add more properties as needed
    }
end

-- Repair vehicle
function Vehicle.Repair()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        NexusCore.UI.ShowNotification('Vehicle repaired')
    end
end

-- Export
exports('Vehicle', function()
    return Vehicle
end)