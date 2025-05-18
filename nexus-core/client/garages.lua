local Garage = {
    _currentGarage = nil,
    _garageVehicles = {}
}

-- Open garage menu
function Garage.Open(garageName)
    Garage._currentGarage = garageName
    
    NexusCore.TriggerServerCallback('nexus:server:getGarageVehicles', function(vehicles)
        Garage._garageVehicles = vehicles
        
        local menu = NexusCore.UI.CreateMenu('garage', 'Garage', 'Select a vehicle')
        
        for _, vehicle in ipairs(vehicles) do
            NexusCore.UI.AddMenuItem('garage', vehicle.plate, vehicle.vehicle, function()
                Garage.SpawnVehicle(vehicle.id)
            end)
        end
        
        NexusCore.UI.ShowMenu('garage')
    end, garageName)
end

-- Store current vehicle
function Garage.Store()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if DoesEntityExist(vehicle) then
        local props = NexusCore.Vehicle.GetProperties(vehicle)
        
        NexusCore.TriggerServerCallback('nexus:server:storeVehicle', function(success)
            if success then
                DeleteEntity(vehicle)
                NexusCore.UI.ShowNotification('Vehicle stored in garage')
            else
                NexusCore.UI.ShowNotification('Failed to store vehicle')
            end
        end, Garage._currentGarage, props)
    else
        NexusCore.UI.ShowNotification('You must be in a vehicle to store it')
    end
end

-- Export
exports('Garage', function()
    return Garage
end)