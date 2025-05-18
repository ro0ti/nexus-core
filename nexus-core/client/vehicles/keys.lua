local VehicleKeys = {
    _keys = {}
}

function VehicleKeys.AddKey(plate)
    VehicleKeys._keys[plate] = true
end

function VehicleKeys.RemoveKey(plate)
    VehicleKeys._keys[plate] = nil
end

function VehicleKeys.HasKey(plate)
    return VehicleKeys._keys[plate] or false
end

-- Lock/unlock vehicle
function VehicleKeys.ToggleLock(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if VehicleKeys.HasKey(plate) then
        local isLocked = GetVehicleDoorLockStatus(vehicle) > 1
        SetVehicleDoorsLocked(vehicle, isLocked and 1 or 2)
        NexusCore.UI.ShowNotification(isLocked and 'Vehicle unlocked' or 'Vehicle locked')
        return true
    end
    return false
end

-- Hotkey for locking
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 303) then -- U key
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle and vehicle ~= 0 then
                VehicleKeys.ToggleLock(vehicle)
            end
        end
    end
end)

exports('AddKey', VehicleKeys.AddKey)
exports('RemoveKey', VehicleKeys.RemoveKey)
exports('HasKey', VehicleKeys.HasKey)