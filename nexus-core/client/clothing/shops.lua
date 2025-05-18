local Clothing = {}

function Clothing.OpenShop(shopType)
    TriggerEvent('fivem-appearance:client:openClothingShop', function()
        NexusCore.UI.ShowNotification('Outfit saved!')
    end, shopType)
end

-- Setup clothing shops
Citizen.CreateThread(function()
    for _,shop in pairs(Config.ClothingShops) do
        local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
        SetBlipSprite(blip, 73)
        SetBlipColour(blip, 47)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop.label)
        EndTextCommandSetBlipName(blip)
        
        exports['nexus-core']:CreateTargetPoint({
            coords = shop.coords,
            radius = 2.0,
            label = shop.label,
            action = function()
                Clothing.OpenShop(shop.type)
            end
        })
    end
end)

exports('OpenShop', Clothing.OpenShop)