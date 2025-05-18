local Enums = {}

Enums.VehicleClasses = {
    [0] = 'Compact',
    [1] = 'Sedan',
    [2] = 'SUV',
    [3] = 'Coupe',
    [4] = 'Muscle',
    [5] = 'Sports Classic',
    [6] = 'Sports',
    [7] = 'Super',
    [8] = 'Motorcycle',
    [9] = 'Off-road',
    [10] = 'Industrial',
    [11] = 'Utility',
    [12] = 'Van',
    [13] = 'Bicycle',
    [14] = 'Boat',
    [15] = 'Helicopter',
    [16] = 'Plane',
    [17] = 'Service',
    [18] = 'Emergency',
    [19] = 'Military'
}

Enums.WeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN'
}

Enums.TimeTypes = {
    MORNING = 6,
    NOON = 12,
    EVENING = 18,
    NIGHT = 0
}

Enums.InventoryTypes = {
    PLAYER = 'player',
    TRUNK = 'trunk',
    GLOVEBOX = 'glovebox',
    DROP = 'drop',
    SHOP = 'shop'
}

return Enums