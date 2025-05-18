local Functions = {}

-- Deep copy table
Functions.DeepCopy = function(table)
    local copy = {}
    for k, v in pairs(table) do
        if type(v) == 'table' then
            copy[k] = Functions.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Table length
Functions.TableLength = function(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

-- Generate random string
Functions.RandomString = function(length)
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    local randomString = ''
    math.randomseed(GetGameTimer())
    
    for i = 1, length do
        local rand = math.random(#chars)
        randomString = randomString .. chars:sub(rand, rand)
    end
    
    return randomString
end

-- Generate vehicle plate
Functions.GeneratePlate = function()
    local plate = Functions.RandomString(1) .. Functions.RandomString(3) .. Functions.RandomString(3)
    return string.upper(plate)
end

-- Format money
Functions.FormatMoney = function(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return '$' .. formatted
end

-- Distance between vectors
Functions.GetDistance = function(vector1, vector2, useZ)
    if not vector1 or not vector2 or not vector1.x or not vector2.x then return 0 end
    return useZ and #(vector1 - vector2) or #(vector1.xy - vector2.xy)
end

-- Check if table has value
Functions.TableContains = function(table, value)
    for _, v in pairs(table) do
        if v == value then return true end
    end
    return false
end

-- Round number
Functions.Round = function(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    end
    return math.floor(value + 0.5)
end

return Functions