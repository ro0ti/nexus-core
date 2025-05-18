local Repair = {}

function Repair.DoRepair(vehicle)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
    
    NexusCore.TriggerServerCallback('nexus:vehicles:canRepair', function(canRepair)
        if canRepair then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            ClearPedTasks(ped)
            NexusCore.UI.ShowNotification('Vehicle repaired')
        end
    end, NetworkGetNetworkIdFromEntity(vehicle))
end

exports('DoRepair', Repair.DoRepair)