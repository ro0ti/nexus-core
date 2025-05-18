local Contacts = {}

function Contacts.GetPlayerContacts(playerId)
    local player = NexusCore.Players.Get(playerId)
    if not player then return {} end
    
    local result = MySQL.query.await('SELECT contacts FROM players WHERE id = ?', {player.id})
    return json.decode(result[1].contacts) or {}
end

function Contacts.AddContact(playerId, name, number)
    local contacts = Contacts.GetPlayerContacts(playerId)
    table.insert(contacts, {name = name, number = number})
    
    MySQL.update.await('UPDATE players SET contacts = ? WHERE id = ?', {
        json.encode(contacts), playerId
    })
    return true
end

NexusCore.Commands.Add('addcontact', 'Add phone contact', {
    {name = 'name', help = 'Contact name'},
    {name = 'number', help = 'Phone number'}
}, function(source, args)
    Contacts.AddContact(source, args[1], args[2])
end)

return Contacts