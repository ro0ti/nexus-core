local NexusClient = {
    PlayerData = {},
    Loaded = false,
    Callbacks = {},
    ResourceName = GetCurrentResourceName()
}

-- Safe event trigger with error handling
function NexusClient.SafeTriggerEvent(eventName, ...)
    if type(eventName) ~= "string" then
        error("eventName must be a string")
    end
    
    local status, err = pcall(TriggerEvent, eventName, ...)
    if not status then
        print(("[%s] Event error: %s"):format(NexusClient.ResourceName, err))
        TriggerServerEvent("nexus:clientError", {
            event = eventName,
            error = err
        })
    end
end

-- Initialize player with timeout
function NexusClient.InitPlayer()
    local startTime = GetGameTimer()
    local timeout = 30000 -- 30 seconds
    
    while not NetworkIsPlayerActive(PlayerId()) do
        if GetGameTimer() - startTime > timeout then
            error("Player activation timeout")
        end
        Citizen.Wait(500)
    end
    
    NexusCore.TriggerServerCallback("nexus:server:playerLoaded", function(playerData)
        if not playerData or type(playerData) ~= "table" then
            error("Invalid player data format")
        end
        
        NexusClient.PlayerData = playerData
        NexusClient.Loaded = true
        
        -- Safe event triggering
        NexusClient.SafeTriggerEvent("nexus:client:playerLoaded", playerData)
    end, function(err)
        print(("[%s] Callback error: %s"):format(NexusClient.ResourceName, err))
    end)
end

-- Safe exports wrapper
function NexusClient.RegisterExport(name, fn)
    if type(name) ~= "string" or type(fn) ~= "function" then
        error("Invalid export registration")
    end
    
    exports(name, function(...)
        local status, result = pcall(fn, ...)
        if not status then
            print(("[%s] Export error (%s): %s"):format(
                NexusClient.ResourceName,
                name,
                result
            ))
            return nil
        end
        return result
    end)
end

-- Register core exports
NexusClient.RegisterExport("GetPlayerData", function()
    return NexusClient.PlayerData
end)

NexusClient.RegisterExport("TriggerCallback", function(name, cb, ...)
    if type(name) ~= "string" then
        error("Callback name must be a string")
    end
    
    if cb and type(cb) ~= "function" then
        error("Callback must be a function or nil")
    end
    
    return NexusCore.TriggerServerCallback(name, function(...)
        if cb then
            local status, err = pcall(cb, ...)
            if not status then
                print(("[%s] Callback error (%s): %s"):format(
                    NexusClient.ResourceName,
                    name,
                    err
                ))
            end
        end
    end, ...)
end)

-- Initialize framework
CreateThread(function()
    local status, err = pcall(NexusClient.InitPlayer)
    if not status then
        print(("[%s] Init error: %s"):format(NexusClient.ResourceName, err))
        TriggerServerEvent("nexus:clientError", {
            context = "framework_init",
            error = err
        })
    end
end)