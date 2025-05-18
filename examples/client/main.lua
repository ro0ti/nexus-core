-- Wait for client to be ready
AddEventHandler('nexus:client:ready', function()
    local Player = exports['nexus-core'].Player()
    local UI = exports['nexus-core'].UI()
    
    -- Example notification
    UI.ShowAdvancedNotification(
        "NexusCore", 
        "Welcome", 
        "You have successfully loaded into the server", 
        "CHAR_DEFAULT", 
        1
    )
    
    -- Example menu creation
    local menu = UI.CreateMenu('main', 'Main Menu', 'Choose an option')
    UI.AddMenuItem('main', 'Option 1', 'First option', function()
        print("Option 1 selected")
    end)
    UI.AddMenuItem('main', 'Option 2', 'Second option', function()
        print("Option 2 selected")
    end)
    
    -- Register key to open menu
    RegisterCommand('openmenu', function()
        UI.ShowMenu('main')
    end)
    
    -- Set key mapping
    RegisterKeyMapping('openmenu', 'Open Main Menu', 'keyboard', 'F5')
end)

-- Example of processing drugs when near a location
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local weedLocation = vector3(222.0, -895.0, 30.0)
        
        if #(playerCoords - weedLocation) < 2.0 then
            NexusCore.UI.ShowHelpNotification('Press ~INPUT_CONTEXT~ to process weed')
            
            if IsControlJustPressed(0, 38) then -- E key
                exports['nexus-core'].Drugs().Process('weed')
            end
        end
    end
end)

-- Example of opening a shop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local ammunationLocation = vector3(12.0, -1106.0, 29.0)
        
        if #(playerCoords - ammunationLocation) < 2.0 then
            NexusCore.UI.ShowHelpNotification('Press ~INPUT_CONTEXT~ to open Ammunation')
            
            if IsControlJustPressed(0, 38) then -- E key
                exports['nexus-core'].Shop().Open('ammunation')
            end
        end
    end
end)