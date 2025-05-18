local Admin = {}

function Admin.Init()
    NexusCore.Commands.Add('admin', 'Admin Menu', {}, function(source)
        TriggerClientEvent('nexus:client:openAdminMenu', source)
    end, 'admin')

    -- Add more admin commands
end

function Admin.KickPlayer(source, target, reason)
    local player = NexusCore.Players.Get(source)
    if player and player.group == 'admin' then
        DropPlayer(target, reason or 'Kicked by admin')
        return true
    end
    return false
end

function Admin.BanPlayer(source, target, reason, duration)
    local player = NexusCore.Players.Get(source)
    if player and player.group == 'admin' then
        local targetPlayer = NexusCore.Players.Get(target)
        if targetPlayer then
            local banData = {
                license = targetPlayer.license,
                reason = reason,
                expire = duration and os.time() + duration or nil,
                bannedBy = player.license
            }
            NexusCore.Database.BanPlayer(banData)
            DropPlayer(target, reason or 'Banned by admin')
            return true
        end
    end
    return false
end

return Admin