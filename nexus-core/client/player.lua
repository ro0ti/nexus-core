local Player = {}

-- Get player ped
function Player.GetPed()
    return PlayerPedId()
end

-- Get player coordinates
function Player.GetCoords()
    return GetEntityCoords(Player.GetPed())
end

-- Teleport player
function Player.Teleport(coords)
    local ped = Player.GetPed()
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
end

-- Check if player is in vehicle
function Player.IsInVehicle()
    return IsPedInAnyVehicle(Player.GetPed(), false)
end

-- Get vehicle
function Player.GetVehicle()
    return GetVehiclePedIsIn(Player.GetPed(), false)
end

-- Export player functions
exports('Player', function()
    return Player
end)