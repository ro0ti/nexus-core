local Admin = {
    Commands = {},
    Logs = {},
    ResourceName = GetCurrentResourceName()
}

-- Permission levels: 0 = user, 1 = mod, 2 = admin, 3 = superadmin
function Admin.HasPermission(playerId, level)
    local player = NexusCore.Players.Get(playerId)
    if not player then return false end
    return (player.metadata?.admin or 0) >= (level or 1)
end

function Admin.BanPlayer(source, targetId, reason, duration)
    if not Admin.HasPermission(source, 2) then
        return false, "no_permission"
    end

    local target = NexusCore.Players.Get(targetId)
    if not target then
        return false, "invalid_target"
    end

    local license = GetPlayerIdentifier(targetId, 0)
    if not license then
        return false, "no_license"
    end

    local banData = {
        license = license,
        reason = reason or "No reason provided",
        bannedBy = GetPlayerIdentifier(source, 0),
        expire = duration and os.time() + duration or nil
    }

    local success, err = MySQL.insert.await(
        'INSERT INTO bans (license, reason, banned_by, expire) VALUES (?, ?, ?, ?)',
        {banData.license, banData.reason, banData.bannedBy, banData.expire}
    )

    if not success then
        return false, "database_error"
    end

    DropPlayer(targetId, ("You have been banned: %s"):format(banData.reason))
    Admin.LogAction(source, "ban", targetId, reason)
    return true
end

function Admin.KickPlayer(source, targetId, reason)
    if not Admin.HasPermission(source, 1) then
        return false, "no_permission"
    end

    local target = NexusCore.Players.Get(targetId)
    if not target then
        return false, "invalid_target"
    end

    DropPlayer(targetId, reason or "You have been kicked")
    Admin.LogAction(source, "kick", targetId, reason)
    return true
end

function Admin.LogAction(source, action, targetId, details)
    local logEntry = {
        admin = GetPlayerIdentifier(source, 0),
        action = action,
        target = GetPlayerIdentifier(targetId, 0),
        details = details,
        timestamp = os.time()
    }

    MySQL.insert.await(
        'INSERT INTO admin_logs (admin, action, target, details, timestamp) VALUES (?, ?, ?, ?, ?)',
        {logEntry.admin, logEntry.action, logEntry.target, logEntry.details, logEntry.timestamp}
    )

    table.insert(Admin.Logs, logEntry)
end

-- Register admin commands
NexusCore.Commands.Add('ban', 'Ban a player', {
    {name = 'id', help = 'Player ID'},
    {name = 'reason', help = 'Ban reason'}
}, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        NexusCore.UI.ShowNotification(source, 'Invalid player ID')
        return
    end

    local reason = table.concat(args, ' ', 2)
    Admin.BanPlayer(source, targetId, reason)
end, 'admin')

NexusCore.Commands.Add('kick', 'Kick a player', {
    {name = 'id', help = 'Player ID'},
    {name = 'reason', help = 'Kick reason'}
}, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        NexusCore.UI.ShowNotification(source, 'Invalid player ID')
        return
    end

    local reason = table.concat(args, ' ', 2)
    Admin.KickPlayer(source, targetId, reason)
end, 'mod')

return Admin