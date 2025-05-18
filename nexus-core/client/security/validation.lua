local Validation = {}

function Validation.ValidateEntity(entity)
    local model = GetEntityModel(entity)
    local coords = GetEntityCoords(entity)
    
    -- Check if entity is blacklisted
    if Config.BlacklistedModels[model] then
        DeleteEntity(entity)
        return false
    end
    
    -- Check if entity is too far from player
    local playerCoords = GetEntityCoords(PlayerPedId())
    if #(coords - playerCoords) > 100.0 then
        DeleteEntity(entity)
        return false
    end
    
    return true
end

-- Anti-cheat checks
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        local playerPed = PlayerPedId()
        
        -- Check for invalid health
        if GetEntityHealth(playerPed) > 200 then
            TriggerServerEvent('nexus:security:flag', 'invalid_health')
        end
        
        -- Check for invalid weapons
        for _,weapon in ipairs(Config.BlacklistedWeapons) do
            if HasPedGotWeapon(playerPed, weapon, false) then
                TriggerServerEvent('nexus:security:flag', 'blacklisted_weapon')
            end
        end
    end
end)

return Validation