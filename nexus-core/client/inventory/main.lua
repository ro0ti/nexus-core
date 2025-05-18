local Inventory = {
    Items = {},
    Open = false,
    Initialized = false,
    ResourceName = GetCurrentResourceName()
}

-- Item validation
function Inventory.IsValidItem(item)
    if type(item) ~= "table" then
        return false
    end
    
    local requiredFields = {
        "name", "label", "weight", "type"
    }
    
    for _, field in ipairs(requiredFields) do
        if item[field] == nil then
            return false
        end
    end
    
    return true
end

-- Safe NUI communication
function Inventory.SendNUIMessage(data)
    if not data or type(data) ~= "table" then
        error("Invalid NUI message data")
    end
    
    local status, err = pcall(SendNUIMessage, data)
    if not status then
        print(("[%s] NUI error: %s"):format(Inventory.ResourceName, err))
        return false
    end
    return true
end

function Inventory.OpenInventory()
    if Inventory.Open then
        return
    end
    
    -- Validate items before sending
    local verifiedItems = {}
    for name, item in pairs(Inventory.Items) do
        if Inventory.IsValidItem(item) then
            verifiedItems[name] = item
        end
    end
    
    Inventory.Items = verifiedItems
    
    -- Open UI
    SetNuiFocus(true, true)
    Inventory.SendNUIMessage({
        action = "openInventory",
        items = verifiedItems
    })
    Inventory.Open = true
end

function Inventory.CloseInventory()
    if not Inventory.Open then
        return
    end
    
    SetNuiFocus(false, false)
    Inventory.SendNUIMessage({ action = "closeInventory" })
    Inventory.Open = false
end

-- Secure NUI callbacks
RegisterNUICallback("closeInventory", function(_, cb)
    Inventory.CloseInventory()
    cb({ success = true })
end)

RegisterNUICallback("useItem", function(data, cb)
    if not data or type(data) ~= "table" then
        cb({ error = "invalid_data" })
        return
    end
    
    if not data.item or type(data.item) ~= "table" then
        cb({ error = "invalid_item" })
        return
    end
    
    if not Inventory.IsValidItem(data.item) then
        cb({ error = "invalid_item_format" })
        return
    end
    
    TriggerServerEvent("nexus:inventory:useItem", data.item.name)
    cb({ success = true })
end)

-- Safe command registration
local function RegisterSafeCommand(name, handler, restricted)
    RegisterCommand(name, function(source, args)
        local status, err = pcall(handler, source, args)
        if not status then
            print(("[%s] Command error (%s): %s"):format(
                Inventory.ResourceName,
                name,
                err
            ))
        end
    end, restricted)
end

RegisterSafeCommand("openInventory", function()
    Inventory.OpenInventory()
end, false)

-- Keybind with fallback
if GetResourceState("ox_lib") == "started" then
    exports.ox_lib:addKeybind({
        name = "inventory",
        description = "Open Inventory",
        defaultKey = "TAB",
        onPressed = function()
            Inventory.OpenInventory()
        end
    })
else
    RegisterKeyMapping("openInventory", "Open Inventory", "keyboard", "TAB")
end

-- Initialize when player loads
AddEventHandler("nexus:client:playerLoaded", function(playerData)
    if playerData.inventory then
        Inventory.Items = playerData.inventory
    end
    Inventory.Initialized = true
end)

-- Cleanup on resource stop
AddEventHandler("onResourceStop", function(resource)
    if resource == Inventory.ResourceName and Inventory.Open then
        SetNuiFocus(false, false)
    end
end)