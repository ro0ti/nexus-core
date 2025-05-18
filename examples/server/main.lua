-- Give item command
NexusCore.Commands.Add('giveitem', 'Give an item to player', {{name = 'id', help = 'Player ID'}, {name = 'item', help = 'Item name'}, {name = 'amount', help = 'Item amount'}}, function(source, args)
    local target = tonumber(args[1])
    local itemName = args[2]
    local amount = tonumber(args[3]) or 1
    
    if NexusCore.Inventory.AddItem(target, itemName, amount) then
        NexusCore.UI.ShowNotification(source, 'Given ' .. amount .. ' ' .. itemName .. ' to player ' .. target)
    else
        NexusCore.UI.ShowNotification(source, 'Failed to give item')
    end
end, 'admin')

-- Set job command
NexusCore.Commands.Add('setjob', 'Set player job', {{name = 'id', help = 'Player ID'}, {name = 'job', help = 'Job name'}, {name = 'grade', help = 'Job grade'}}, function(source, args)
    local target = tonumber(args[1])
    local jobName = args[2]
    local grade = tonumber(args[3]) or 0
    
    if NexusCore.Jobs.SetJob(target, jobName, grade) then
        NexusCore.UI.ShowNotification(source, 'Set job for player ' .. target .. ' to ' .. jobName)
    else
        NexusCore.UI.ShowNotification(source, 'Failed to set job')
    end
end, 'admin')

-- Register a secure event
NexusCore.Events.RegisterServer('nexus:requestCharacter', function(source, characterId)
    -- Validate character belongs to player
    local player = NexusCore.Players.Get(source, true)
    local character = NexusCore.Database.GetCharacter(characterId)
    
    if character and character.license == player.license then
        NexusCore.Events.TriggerClient(source, 'nexus:characterLoaded', character)
    else
        DropPlayer(source, "Invalid character request")
    end
end, {
    authRequired = true,
    validate = function(characterId)
        return type(characterId) == 'number', "Character ID must be a number"
    end
})