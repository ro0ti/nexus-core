local Inventory = {
    PlayerInventories = {},
    ItemDefinitions = {},
    CacheTime = 5 * 60 * 1000, -- 5 minutes
    ResourceName = GetCurrentResourceName()
}

-- Load items with validation
function Inventory.LoadItems()
    local items, err = MySQL.query.await("SELECT * FROM items")
    if not items then
        error(("Failed to load items: %s"):format(err))
    end
    
    for _, item in ipairs(items) do
        if item.name and item.label then
            -- Validate item data
            if not item.weight then item.weight = 100 end
            if not item.type then item.type = "misc" end
            
            Inventory.ItemDefinitions[item.name] = item
        end
    end
end

-- Get player inventory with caching
function Inventory.GetPlayerInventory(playerId)
    if type(playerId) ~= "number" then
        error("Invalid player ID")
    end
    
    local player = NexusCore.Players.Get(playerId)
    if not player then
        return nil
    end
    
    -- Check cache
    local cache = Inventory.PlayerInventories[playerId]
    if cache and (GetGameTimer() - cache.timestamp) < Inventory.CacheTime then
        return cache.inventory
    end
    
    -- Query database
    local result, err = MySQL.query.await(
        "SELECT inventory FROM players WHERE id = ?",
        { playerId }
    )
    
    if not result or not result[1] then
        print(("[%s] Inventory query error: %s"):format(
            Inventory.ResourceName,
            err or "no results"
        ))
        return nil
    end
    
    -- Decode and validate inventory
    local inventory = {}
    local success, decoded = pcall(json.decode, result[1].inventory or "{}")
    
    if success and type(decoded) == "table" then
        for name, count in pairs(decoded) do
            if Inventory.ItemDefinitions[name] and type(count) == "number" then
                inventory[name] = count
            end
        end
    end
    
    -- Update cache
    Inventory.PlayerInventories[playerId] = {
        inventory = inventory,
        timestamp = GetGameTimer()
    }
    
    return inventory
end

-- Item usage handler
function Inventory.UseItem(playerId, itemName)
    if type(itemName) ~= "string" then
        return false
    end
    
    local player = NexusCore.Players.Get(playerId)
    if not player then
        return false
    end
    
    local inventory = Inventory.GetPlayerInventory(playerId)
    if not inventory then
        return false
    end
    
    -- Check item exists and player has it
    local itemDef = Inventory.ItemDefinitions[itemName]
    if not itemDef then
        return false
    end
    
    if not inventory[itemName] or inventory[itemName] <= 0 then
        return false
    end
    
    -- Process item use based on type
    local success = false
    
    if itemDef.type == "food" then
        success = TriggerClientEvent("nexus:client:heal", playerId, itemDef.metadata?.healAmount or 10)
    elseif itemDef.type == "weapon" then
        success = TriggerClientEvent("nexus:client:giveWeapon", playerId, itemName)
    end
    
    -- Update inventory if successful
    if success then
        inventory[itemName] = inventory[itemName] - 1
        if inventory[itemName] <= 0 then
            inventory[itemName] = nil
        end
        
        -- Update database
        MySQL.update(
            "UPDATE players SET inventory = ? WHERE id = ?",
            { json.encode(inventory), playerId }
        )
        
        -- Update cache
        if Inventory.PlayerInventories[playerId] then
            Inventory.PlayerInventories[playerId].inventory = inventory
            Inventory.PlayerInventories[playerId].timestamp = GetGameTimer()
        end
    end
    
    return success
end

-- Secure event handlers
RegisterNetEvent("nexus:inventory:useItem", function(itemName)
    local playerId = source
    
    if type(itemName) ~= "string" then
        return
    end
    
    local status, result = pcall(Inventory.UseItem, playerId, itemName)
    if not status then
        print(("[%s] Use item error: %s"):format(
            Inventory.ResourceName,
            result
        ))
    end
end)

-- Cache cleanup
CreateThread(function()
    while true do
        Citizen.Wait(Inventory.CacheTime)
        
        local currentTime = GetGameTimer()
        for playerId, cache in pairs(Inventory.PlayerInventories) do
            if (currentTime - cache.timestamp) >= Inventory.CacheTime then
                Inventory.PlayerInventories[playerId] = nil
            end
        end
    end
end)

-- Initialize
AddEventHandler("onResourceStart", function(resource)
    if resource == Inventory.ResourceName then
        local status, err = pcall(Inventory.LoadItems)
        if not status then
            print(("[%s] Critical error: %s"):format(
                Inventory.ResourceName,
                err
            ))
        end
    end
end)