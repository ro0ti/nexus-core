local Inventory = {
    _playerInventories = {},
    _sharedInventories = {},
    _itemDefinitions = {}
}

-- Load item definitions from database
function Inventory.LoadItems()
    local items = MySQL.query.await('SELECT * FROM items')
    for _, item in ipairs(items) do
        Inventory._itemDefinitions[item.name] = item
    end
end

-- Get player inventory
function Inventory.Get(playerId)
    if not Inventory._playerInventories[playerId] then
        local result = MySQL.query.await('SELECT inventory FROM players WHERE id = ?', {playerId})
        Inventory._playerInventories[playerId] = json.decode(result[1].inventory) or {}
    end
    return Inventory._playerInventories[playerId]
end

-- Add item to player inventory
function Inventory.AddItem(playerId, itemName, amount)
    amount = amount or 1
    local inventory = Inventory.Get(playerId)
    
    if Inventory._itemDefinitions[itemName] then
        if inventory[itemName] then
            inventory[itemName] = inventory[itemName] + amount
        else
            inventory[itemName] = amount
        end
        
        -- Update database
        MySQL.update.await('UPDATE players SET inventory = ? WHERE id = ?', {json.encode(inventory), playerId})
        return true
    end
    return false
end

-- Remove item from player inventory
function Inventory.RemoveItem(playerId, itemName, amount)
    amount = amount or 1
    local inventory = Inventory.Get(playerId)
    
    if inventory[itemName] and inventory[itemName] >= amount then
        inventory[itemName] = inventory[itemName] - amount
        
        if inventory[itemName] <= 0 then
            inventory[itemName] = nil
        end
        
        MySQL.update.await('UPDATE players SET inventory = ? WHERE id = ?', {json.encode(inventory), playerId})
        return true
    end
    return false
end

-- Check if player has item
function Inventory.HasItem(playerId, itemName, amount)
    amount = amount or 1
    local inventory = Inventory.Get(playerId)
    return inventory[itemName] and inventory[itemName] >= amount
end

return Inventory