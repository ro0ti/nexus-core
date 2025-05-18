local Drugs = {
    _processing = false,
    _selling = false
}

-- Process drugs
function Drugs.Process(drugType)
    if Drugs._processing then return end
    
    Drugs._processing = true
    NexusCore.UI.ShowNotification('Processing ' .. drugType .. '...')
    
    -- Play animation
    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
    
    NexusCore.TriggerServerCallback('nexus:server:processDrugs', function(success)
        Drugs._processing = false
        ClearPedTasks(PlayerPedId())
        
        if success then
            NexusCore.UI.ShowNotification('Successfully processed ' .. drugType)
        else
            NexusCore.UI.ShowNotification('Failed to process ' .. drugType)
        end
    end, drugType)
end

-- Sell drugs
function Drugs.Sell(drugType, amount)
    if Drugs._selling then return end
    
    Drugs._selling = true
    
    -- Play animation
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    
    NexusCore.TriggerServerCallback('nexus:server:sellDrugs', function(success, price)
        Drugs._selling = false
        ClearPedTasks(PlayerPedId())
        
        if success then
            NexusCore.UI.ShowNotification('Sold ' .. amount .. ' ' .. drugType .. ' for $' .. price)
        else
            NexusCore.UI.ShowNotification('Failed to sell drugs')
        end
    end, drugType, amount)
end

-- Check for processing locations
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for drugType, location in pairs(NexusCore.Config.DrugProcessing) do
            local dist = #(playerCoords - location.coords)
            
            if dist < 2.0 then
                NexusCore.UI.ShowHelpNotification('Press ~INPUT_CONTEXT~ to process ' .. drugType)
                
                if IsControlJustPressed(0, 38) then -- E key
                    Drugs.Process(drugType)
                end
            end
        end
    end
end)

-- Export
exports('Drugs', function()
    return Drugs
end)