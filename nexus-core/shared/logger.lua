local Logger = {}

Logger.Log = function(message, level, resource)
    level = level or 'info'
    resource = resource or GetCurrentResourceName()
    
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local formatted = string.format('[%s] [%s] [%s] %s', timestamp, string.upper(level), resource, message)
    
    if level == 'error' then
        print('\27[31m' .. formatted .. '\27[0m')
    elseif level == 'warning' then
        print('\27[33m' .. formatted .. '\27[0m')
    elseif level == 'success' then
        print('\27[32m' .. formatted .. '\27[0m')
    elseif level == 'info' then
        print('\27[36m' .. formatted .. '\27[0m')
    else
        print(formatted)
    end
end

Logger.Debug = function(message, resource)
    if Config.DebugMode then
        Logger.Log(message, 'debug', resource)
    end
end

Logger.Error = function(message, resource)
    Logger.Log(message, 'error', resource)
end

Logger.Warning = function(message, resource)
    Logger.Log(message, 'warning', resource)
end

Logger.Success = function(message, resource)
    Logger.Log(message, 'success', resource)
end

Logger.Info = function(message, resource)
    Logger.Log(message, 'info', resource)
end

return Logger