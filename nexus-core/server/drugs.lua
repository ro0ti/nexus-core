local Drugs = {
    _processingLocations = {},
    _sellingLocations = {}
}

-- Load drug locations from config
function Drugs.LoadLocations()
    Drugs._processingLocations = {
        ['weed'] = {
            coords = vector3(222.0, -895.0, 30.0),
            requiredItems = {'weed_seed', 'fertilizer'},
            outputItem = 'weed',
            outputAmount = 5,
            processingTime = 30000 -- 30 seconds
        }
        -- Add other drug types
    }
    
    Drugs._sellingLocations = {
        vector3(100.0, -200.0, 30.0),
        vector3(150.0, -250.0, 30.0)
        -- Add more locations
    }
end

-- Process drugs
function Drugs.ProcessDrugs(playerId, drugType)
    local location = Drugs._processingLocations[drugType]
    if not location then return false end
    
    local player = NexusCore.Players.Get(playerId)
    if not player then return false end
    
    -- Check if player has required items
    for _, item in ipairs(location.requiredItems) do
        if not NexusCore.Inventory.HasItem(playerId, item, 1) then
            return false
        end
    end
    
    -- Remove required items
    for _, item in ipairs(location.requiredItems) do
        NexusCore.Inventory.RemoveItem(playerId, item, 1)
    end
    
    -- Add processed drugs after delay
    Citizen.SetTimeout(location.processingTime, function()
        NexusCore.Inventory.AddItem(playerId, location.outputItem, location.outputAmount)
        TriggerClientEvent('nexus:client:drugsProcessed', playerId, drugType, location.outputAmount)
    end)
    
    return true
end

-- Sell drugs
function Drugs.SellDrugs(playerId, drugType, amount)
    local player = NexusCore.Players.Get(playerId)
    if not player then return false end
    
    if not NexusCore.Inventory.HasItem(playerId, drugType, amount) then
        return false
    end
    
    -- Calculate price (base price + random factor)
    local basePrice = NexusCore.Inventory._itemDefinitions[drugType]?.price or 10
    local price = math.floor(basePrice * amount * (0.8 + math.random() * 0.4))
    
    NexusCore.Inventory.RemoveItem(playerId, drugType, amount)
    NexusCore.AddMoney(playerId, 'cash', price)
    
    TriggerClientEvent('nexus:client:drugsSold', playerId, drugType, amount, price)
    return true
end

return Drugs