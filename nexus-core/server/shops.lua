local Shops = {
    _shops = {}
}

-- Load shops from database
function Shops.LoadShops()
    local result = MySQL.query.await('SELECT * FROM shops')
    for _, shop in ipairs(result) do
        shop.items = json.decode(shop.items)
        Shops._shops[shop.name] = shop
    end
end

-- Purchase item from shop
function Shops.PurchaseItem(playerId, shopName, itemName, amount)
    amount = amount or 1
    
    local shop = Shops._shops[shopName]
    if not shop then return false end
    
    local itemData = shop.items[itemName]
    if not itemData then return false end
    
    local totalPrice = itemData.price * amount
    
    -- Check if player has enough money
    if not NexusCore.HasMoney(playerId, shop.currency or 'cash', totalPrice) then
        return false, 'not_enough_money'
    end
    
    -- Check if shop has enough stock
    if itemData.stock and itemData.stock < amount then
        return false, 'not_enough_stock'
    end
    
    -- Process transaction
    NexusCore.RemoveMoney(playerId, shop.currency or 'cash', totalPrice)
    NexusCore.Inventory.AddItem(playerId, itemName, amount)
    
    -- Update stock if needed
    if itemData.stock then
        itemData.stock = itemData.stock - amount
        MySQL.update.await(
            'UPDATE shops SET items = ? WHERE name = ?',
            {json.encode(shop.items), shopName}
        )
    end
    
    return true
end

-- Sell item to shop
function Shops.SellItem(playerId, shopName, itemName, amount)
    amount = amount or 1
    
    local shop = Shops._shops[shopName]
    if not shop then return false end
    
    local itemData = shop.items[itemName]
    if not itemData then return false end
    
    -- Check if player has item
    if not NexusCore.Inventory.HasItem(playerId, itemName, amount) then
        return false, 'not_enough_items'
    end
    
    local sellPrice = math.floor((itemData.price * 0.7) * amount)
    
    -- Process transaction
    NexusCore.Inventory.RemoveItem(playerId, itemName, amount)
    NexusCore.AddMoney(playerId, shop.currency or 'cash', sellPrice)
    
    -- Update stock if needed
    if itemData.stock then
        itemData.stock = itemData.stock + amount
        MySQL.update.await(
            'UPDATE shops SET items = ? WHERE name = ?',
            {json.encode(shop.items), shopName}
        )
    end
    
    return true, sellPrice
end

return Shops