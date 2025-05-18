local Debug = {}

function Debug.ToggleDebug()
    local debugState = not Config.DebugMode
    TriggerServerEvent('nexus:dev:setDebug', debugState)
    NexusCore.UI.ShowNotification(('Debug mode %s'):format(debugState and 'enabled' or 'disabled'))
end

function Debug.PrintTable(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            Debug.PrintTable(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end

-- Debug commands
RegisterCommand('debug', function()
    Debug.ToggleDebug()
end, false)

RegisterCommand('printplayer', function()
    local player = exports['nexus-core']:GetPlayerData()
    Debug.PrintTable(player)
end, false)

exports('PrintTable', Debug.PrintTable)