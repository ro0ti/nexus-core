local Events = {}

-- Register secure server event
function Events.RegisterServer(eventName, handler, options)
    options = options or {}
    
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(...)
        local src = source
        
        -- Rate limiting
        if not Events._checkRateLimit(src, eventName) then
            print(("^1[Security] %s kicked for event spam (Event: %s)^0"):format(GetPlayerName(src), eventName))
            DropPlayer(src, "Event spam detected")
            return
        end
        
        -- Authentication
        if options.authRequired then
            local player = NexusCore.Players.Get(src, true)
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

-- Trigger client event with security
function Events.TriggerClient(target, eventName, payload, options)
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

-- Rate limiting check
function Events._checkRateLimit(source, eventName)
    local rateConfig = NexusCore._security.eventRateLimits[eventName]
    if not rateConfig then return true end
    
    local now = os.time()
    local playerBucket = rateConfig.buckets[source] or {
        count = 0,
        lastReset = now
    }
    
    if now - playerBucket.lastReset >= 60 then
        playerBucket.count = 0
        playerBucket.lastReset = now
    end
    
    if playerBucket.count >= rateConfig.limit then
        return false
    end
    
    playerBucket.count = playerBucket.count + 1
    rateConfig.buckets[source] = playerBucket
    
    return true
end

return Events