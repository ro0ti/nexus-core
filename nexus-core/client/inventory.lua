local Inventory = {
    _open = false,
    _items = {}
}

-- Open inventory
function Inventory.Open()
    if Inventory._open then return end
    
    Inventory._open = true
    SetNuiFocus(true, true)
    
    -- Get player inventory
    NexusCore.TriggerServerCallback('nexus:server:getInventory', function(items)
        Inventory._items = items
        SendNUIMessage({
            action = 'openInventory',
            items = items
        })
    end)
end

-- Close inventory
function Inventory.Close()
    if not Inventory._open then return end
    
    Inventory._open = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeInventory'
    })
end

-- Use item
function Inventory.UseItem(itemName)
    NexusCore.TriggerServerCallback('nexus:server:useItem', function(success)
        if success then
            -- Play animation or effect
        end
    end, itemName)
end

-- NUI callbacks
RegisterNUICallback('closeInventory', function(_, cb)
    Inventory.Close()
    cb({})
end)

RegisterNUICallback('useItem', function(data, cb)
    Inventory.UseItem(data.item)
    cb({})
end)

-- Keybind
RegisterCommand('openInventory', function()
    Inventory.Open()
end)

RegisterKeyMapping('openInventory', 'Open Inventory', 'keyboard', 'TAB')

-- Export
exports('OpenInventory', function()
    Inventory.Open()
end)