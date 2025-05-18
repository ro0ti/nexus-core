local NexusServer = {
    Players = {},
    Config = {},
    Modules = {},
    Initialized = false,
    ResourceName = GetCurrentResourceName()
}

-- Safe config loader
function NexusServer.LoadConfig()
    local configFile = LoadResourceFile(NexusServer.ResourceName, "config.lua")
    if not configFile then
        error("Config file not found")
    end
    
    local configFn, err = load(configFile, ("@@%s/config.lua"):format(NexusServer.ResourceName))
    if not configFn then
        error(("Failed to load config: %s"):format(err))
    end
    
    -- Execute in protected environment
    local env = setmetatable({}, { __index = _G })
    setfenv(configFn, env)
    
    local status, config = pcall(configFn)
    if not status then
        error(("Config execution error: %s"):format(config))
    end
    
    if type(config) ~= "table" then
        error("Config must return a table")
    end
    
    -- Validate required config sections
    local requiredSections = {
        "Framework", "Database", "Inventory"
    }
    
    for _, section in ipairs(requiredSections) do
        if not config[section] then
            error(("Missing config section: %s"):format(section))
        end
    end
    
    return config
end

-- Safe module loader
function NexusServer.LoadModule(modulePath)
    local status, module = pcall(require, modulePath)
    if not status then
        error(("Failed to load module %s: %s"):format(modulePath, module))
    end
    
    local moduleName = modulePath:match("([^/]+)$")
    if not moduleName then
        error(("Invalid module path: %s"):format(modulePath))
    end
    
    return moduleName, module
end

-- Database connection with retries
function NexusServer.ConnectDatabase(config, maxRetries)
    maxRetries = maxRetries or 3
    local retries = 0
    
    while retries < maxRetries do
        local status, err = pcall(NexusServer.Database.Connect, config)
        if status then
            return true
        end
        
        retries = retries + 1
        print(("[%s] Database connection failed (attempt %d/%d): %s"):format(
            NexusServer.ResourceName,
            retries,
            maxRetries,
            err
        ))
        
        if retries < maxRetries then
            Citizen.Wait(5000) -- Wait 5 seconds before retry
        end
    end
    
    error("Failed to connect to database after "..maxRetries.." attempts")
end

-- Initialize framework
function NexusServer.Init()
    if NexusServer.Initialized then
        return
    end
    
    -- Load config
    NexusServer.Config = NexusServer.LoadConfig()
    
    -- Load core modules
    local coreModules = {
        "server/players",
        "server/events",
        "server/database",
        "server/commands"
    }
    
    for _, modulePath in ipairs(coreModules) do
        local moduleName, module = NexusServer.LoadModule(modulePath)
        NexusServer.Modules[moduleName] = module
    end
    
    -- Connect to database
    NexusServer.ConnectDatabase(NexusServer.Config.Database)
    
    -- Initialize modules
    for name, module in pairs(NexusServer.Modules) do
        if type(module.Init) == "function" then
            local status, err = pcall(module.Init, NexusServer.Config)
            if not status then
                error(("Failed to initialize %s: %s"):format(name, err))
            end
        end
    end
    
    NexusServer.Initialized = true
    print(("[%s] Framework initialized"):format(NexusServer.ResourceName))
end

-- Secure player connection handler
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()
    local player = source
    
    -- Validate identifiers
    local identifiers = GetPlayerIdentifiers(player)
    if not identifiers or #identifiers == 0 then
        deferrals.done("[NexusCore] Unable to verify your identity")
        return
    end
    
    local license = GetPlayerIdentifier(player, 0)
    if not license then
        deferrals.done("[NexusCore] Invalid license identifier")
        return
    end
    
    -- Check bans
    local isBanned, banReason = pcall(NexusServer.Modules.database.IsBanned, license)
    if not isBanned then
        print(("[%s] Ban check error: %s"):format(NexusServer.ResourceName, banReason))
        deferrals.done("[NexusCore] Authentication error")
        return
    end
    
    if banReason then
        deferrals.done(banReason)
        return
    end
    
    deferrals.done()
end)

-- Initialize framework with error handling
CreateThread(function()
    local status, err = pcall(NexusServer.Init)
    if not status then
        print(("[%s] Critical init error: %s"):format(NexusServer.ResourceName, err))
        
        -- Prevent resource from starting if critical systems fail
        AddEventHandler("onResourceStart", function(resource)
            if resource == NexusServer.ResourceName then
                error(("Failed to initialize: %s"):format(err))
            end
        end)
    end
end)