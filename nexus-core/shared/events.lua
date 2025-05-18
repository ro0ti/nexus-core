local Events = {}

-- Register and trigger events with security checks
Events.RegisterNet = function(eventName, handler, options)
    options = options or {}
    
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(...)
        local src = source
        
        -- Rate limiting
        if options.rateLimit and not Events.CheckRateLimit(src, eventName, options.rateLimit) then
            print(("^1[Security] %s kicked for event spam (Event: %s)^0"):format(GetPlayerName(src), eventName))
            DropPlayer(src, "Event spam detected")
            return
        end
        
        -- Authentication
        if options.authRequired then
            local player = exports['nexus-core']:GetPlayer(src)
            if not player then return end
        end
        
        -- Parameter validation
        if options.validate then
            local isValid, err = options.validate(...)
            if not isValid then
                print(("^1[Security] Invalid event params from %s: %s^0"):format(GetPlayerName(src), err))
                return
            end
        end
        
        -- Protected execution
        local success, err = pcall(handler, src, ...)
        if not success then
            print(("^1[Error] Event %s failed: %s^0"):format(eventName, err))
        end
    end)
end

Events.TriggerClient = function(target, eventName, payload, options)
    options = options or {}
    payload = payload or {}
    
    if options.validate then
        local isValid, err = options.validate(payload)
        if not isValid then
            print(("^1[Security] Invalid payload for event %s: %s^0"):format(eventName, err))
            return
        end
    end
    
    TriggerClientEvent(eventName, target, payload)
end

Events.TriggerAllClients = function(eventName, payload, options)
    Events.TriggerClient(-1, eventName, payload, options)
end

Events.CheckRateLimit = function(source, eventName, limit)
    local now = os.time()
    local bucket = Events._rateLimits[eventName] or {}
    local playerBucket = bucket[source] or { count = 0, lastReset = now }
    
    if now - playerBucket.lastReset >= 60 then
        playerBucket.count = 0
        playerBucket.lastReset = now
    end
    
    if playerBucket.count >= limit then
        return false
    end
    
    playerBucket.count = playerBucket.count + 1
    bucket[source] = playerBucket
    Events._rateLimits[eventName] = bucket
    
    return true
end

Events._rateLimits = {}

return Events