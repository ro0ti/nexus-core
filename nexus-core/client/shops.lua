local Shop = {
    _currentShop = nil
}

-- Open shop menu
function Shop.Open(shopName)
    Shop._currentShop = shopName
    
    NexusCore.TriggerServerCallback('nexus:server:getShopItems', function(items)
        local menu = NexusCore.UI.CreateMenu('shop', 'Shop', 'Browse items')
        
        for itemName, itemData in pairs(items) do
            NexusCore.UI.AddMenuItem('shop', 
                itemData.label .. ' - $' .. itemData.price,
                'Stock: ' .. (itemData.stock or '∞'),
                function()
                    Shop.PurchaseItem(itemName)
                end
            )
        end
        
        NexusCore.UI.ShowMenu('shop')
    end, shopName)
end

-- Purchase item
function Shop.PurchaseItem(itemName)
    NexusCore.UI.OpenDialog('amount', 'Enter amount', function(amount)
        amount = tonumber(amount)
        
        if amount and amount > 0 then
            NexusCore.TriggerServerCallback('nexus:server:purchaseItem', function(success, reason)
                if success then
                    NexusCore.UI.ShowNotification('Purchased ' .. amount .. ' ' .. itemName)
                else
                    NexusCore.UI.ShowNotification('Purchase failed: ' .. (reason or 'unknown error'))
                end
            end, Shop._currentShop, itemName, amount)
        end
    end)
end

-- Check for nearby shops
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for shopName, shopData in pairs(NexusCore.Config.Shops) do
            local dist = #(playerCoords - shopData.coords)
            
            if dist < 2.0 then
                NexusCore.UI.ShowHelpNotification('Press ~INPUT_CONTEXT~ to open ' .. shopData.label)
                
                if IsControlJustPressed(0, 38) then -- E key
                    Shop.Open(shopName)
                end
            end
        end
    end
end)

-- Export
exports('Shop', function()
    return Shop
end)