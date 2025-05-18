local Notifications = {}

function Notifications.ShowPhoneNotification(data)
    SendNUIMessage({
        action = 'phoneNotification',
        data = data
    })
end

RegisterNetEvent('nexus:phone:notification')
AddEventHandler('nexus:phone:notification', function(data)
    Notifications.ShowPhoneNotification(data)
end)

exports('ShowNotification', Notifications.ShowPhoneNotification)