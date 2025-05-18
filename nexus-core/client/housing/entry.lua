local Housing = {
    currentHouse = nil,
    houses = {}
}

function Housing.AddHouse(data)
    Housing.houses[data.id] = data
    
    Citizen.CreateThread(function()
        local marker = vector3(data.entry.x, data.entry.y, data.entry.z)
        while true do
            Citizen.Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - marker)
            
            if dist < 2.0 then
                NexusCore.UI.ShowHelpNotification('Press ~INPUT_CONTEXT~ to enter '..data.label)
                if IsControlJustPressed(0, 38) then
                    Housing.EnterHouse(data.id)
                end
            elseif dist < 20.0 then
                DrawMarker(2, marker.x, marker.y, marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 30, 150, 200, 200, false, true, 2, false)
            end
        end
    end)
end

function Housing.EnterHouse(houseId)
    local house = Housing.houses[houseId]
    if house then
        TriggerServerEvent('nexus:housing:enter', houseId)
    end
end

RegisterNetEvent('nexus:housing:entered')
AddEventHandler('nexus:housing:entered', function(houseId, interior)
    Housing.currentHouse = houseId
    SetEntityCoords(PlayerPedId(), interior.x, interior.y, interior.z)
end)

exports('AddHouse', Housing.AddHouse)