local Callbacks = {}

-- Register server callback
Callbacks.RegisterServerCallback = function(name, callback)
    RegisterServerEvent('nexus:server:triggerCallback:' .. name)
    AddEventHandler('nexus:server:triggerCallback:' .. name, function(requestId, ...)
        local src = source
        local response = callback(src, ...)
        TriggerClientEvent('nexus:client:receiveCallback:' .. name, src, requestId, response)
    end)
end

-- Trigger server callback from client
Callbacks.TriggerServerCallback = function(name, callback, ...)
    local requestId = math.random(1, 1000000)
    
    RegisterNetEvent('nexus:client:receiveCallback:' .. name)
    local event = AddEventHandler('nexus:client:receiveCallback:' .. name, function(receivedId, response)
        if receivedId == requestId then
            RemoveEventHandler(event)
            callback(response)
        end
    end)
    
    TriggerServerEvent('nexus:server:triggerCallback:' .. name, requestId, ...)
end

-- Register client callback
Callbacks.RegisterClientCallback = function(name, callback)
    RegisterNetEvent('nexus:client:triggerCallback:' .. name)
    AddEventHandler('nexus:client:triggerCallback:' .. name, function(requestId, ...)
        local src = source
        local response = callback(src, ...)
        TriggerClientEvent('nexus:server:receiveCallback:' .. name, src, requestId, response)
    end)
end

-- Trigger client callback from server
Callbacks.TriggerClientCallback = function(target, name, callback, ...)
    local requestId = math.random(1, 1000000)
    
    RegisterNetEvent('nexus:server:receiveCallback:' .. name)
    local event = AddEventHandler('nexus:server:receiveCallback:' .. name, function(receivedId, response)
        if receivedId == requestId then
            RemoveEventHandler(event)
            callback(response)
        end
    end)
    
    TriggerClientEvent('nexus:client:triggerCallback:' .. name, target, requestId, ...)
end

return Callbacks