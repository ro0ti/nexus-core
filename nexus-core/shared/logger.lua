local Logger = {
    Levels = {
        DEBUG = 0,
        INFO = 1,
        WARN = 2,
        ERROR = 3
    },
    ResourceName = GetCurrentResourceName()
}

function Logger.Log(level, message, data)
    if not message or type(message) ~= 'string' then
        error('Invalid log message')
    end

    local logEntry = {
        level = level,
        message = message,
        resource = Logger.ResourceName,
        timestamp = os.time(),
        data = data or nil
    }

    -- Console output
    local color = Logger.GetLogColor(level)
    print(('^%d[%s] %s^0'):format(color, level, message))

    -- Database storage
    if Config.LogToDatabase then
        MySQL.insert.await(
            'INSERT INTO server_logs (level, message, resource, data) VALUES (?, ?, ?, ?)',
            {level, message, Logger.ResourceName, json.encode(data)}
        )
    end

    -- Discord webhook
    if Config.DiscordWebhooks?.logs then
        TriggerEvent('nexus:discord:log', {
            title = ('[%s] %s'):format(level, Logger.ResourceName),
            description = message,
            color = color,
            fields = data and {
                {name = 'Details', value = json.encode(data)}
            } or nil
        })
    end
end

function Logger.GetLogColor(level)
    local colors = {
        [Logger.Levels.DEBUG] = 7,  -- Light gray
        [Logger.Levels.INFO] = 2,   -- Green
        [Logger.Levels.WARN] = 3,   -- Yellow
        [Logger.Levels.ERROR] = 1    -- Red
    }
    return colors[level] or 7
end

-- Helper methods
function Logger.Debug(msg, data)
    Logger.Log(Logger.Levels.DEBUG, msg, data)
end

function Logger.Info(msg, data)
    Logger.Log(Logger.Levels.INFO, msg, data)
end

function Logger.Warn(msg, data)
    Logger.Log(Logger.Levels.WARN, msg, data)
end

function Logger.Error(msg, data)
    Logger.Log(Logger.Levels.ERROR, msg, data)
end

return Logger