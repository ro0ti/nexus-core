local Phone = {
    apps = {}
}

function Phone.RegisterApp(name, data)
    Phone.apps[name] = data
end

function Phone.ShowApp(name)
    if Phone.apps[name] then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'showApp',
            app = name,
            data = Phone.apps[name]
        })
    end
end

-- Default apps
Phone.RegisterApp('contacts', {
    name = 'Contacts',
    icon = 'user-friends',
    color = '#3498db'
})

Phone.RegisterApp('messages', {
    name = 'Messages',
    icon = 'comments',
    color = '#2ecc71'
})

RegisterNUICallback('phoneBack', function(_, cb)
    SetNuiFocus(false, false)
    cb({})
end)

exports('RegisterApp', Phone.RegisterApp)
exports('ShowApp', Phone.ShowApp)