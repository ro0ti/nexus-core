local Discord = {}

function Discord.SendToDiscord(webhook, message, color)
    local embed = {
        {
            ["color"] = color or 16711680,
            ["title"] = message.title or "NexusCore Log",
            ["description"] = message.description or "",
            ["fields"] = message.fields or {},
            ["footer"] = {
                ["text"] = os.date("%c")
            }
        }
    }
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'NexusCore',
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Example usage
RegisterNetEvent('nexus:discord:log')
AddEventHandler('nexus:discord:log', function(message)
    Discord.SendToDiscord(Config.DiscordWebhooks.default, message)
end)

return Discord