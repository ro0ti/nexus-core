local States = {}

function States.SaveVehicleState(netId, state)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    MySQL.update('UPDATE player_vehicles SET state = ?, metadata = ? WHERE plate = ?', {
        state,
        json.encode(state),
        plate
    })
end

RegisterNetEvent('nexus:vehicles:saveState')
AddEventHandler('nexus:vehicles:saveState', function(netId, state)
    States.SaveVehicleState(netId, state)
end)

return States