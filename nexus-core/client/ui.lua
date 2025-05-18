local UI = {
    _activeMenus = {},
    _notifications = {}
}

-- Show advanced notification
function UI.ShowAdvancedNotification(title, subject, msg, icon, iconType)
    AddTextEntry('nexusNotification', msg)
    BeginTextCommandThefeedPost('nexusNotification')
    EndTextCommandThefeedPostMessagetext(icon, icon, false, iconType, title, subject)
    EndTextCommandThefeedPostTicker(false, true)
end

-- Create menu
function UI.CreateMenu(id, title, subtitle, position)
    UI._activeMenus[id] = {
        id = id,
        title = title,
        subtitle = subtitle,
        position = position or 'top-left',
        items = {},
        currentItem = 1
    }
    return UI._activeMenus[id]
end

-- Add menu item
function UI.AddMenuItem(menuId, label, description, callback)
    if UI._activeMenus[menuId] then
        table.insert(UI._activeMenus[menuId].items, {
            label = label,
            description = description,
            callback = callback
        })
    end
end

-- Show menu
function UI.ShowMenu(menuId)
    -- Implementation would show the menu using Scaleform or NUI
    -- This is a placeholder for the example
    print(("Showing menu: %s"):format(menuId))
end

-- Export UI functions
exports('UI', function()
    return UI
end)