Config = {}

-- Core Framework Settings
Config.FrameworkName = 'NexusCore'
Config.FrameworkVersion = '1.0.0'
Config.DebugMode = true
Config.MaintenanceMode = false
Config.WhitelistEnabled = false

-- Player Settings
Config.StartingCash = 5000
Config.StartingBank = 10000
Config.MaxWeight = 30000 -- 30kg
Config.MaxInventorySlots = 50

-- Job System
Config.DefaultJob = 'unemployed'
Config.DefaultJobGrade = 0
Config.PaycheckInterval = 30 * 60 * 1000 -- 30 minutes

-- Gang System
Config.DefaultGang = 'none'
Config.DefaultGangGrade = 0

-- Vehicle System
Config.DefaultGarage = 'legion'
Config.VehicleParkDistance = 25.0
Config.VehicleSpawnDistance = 50.0

-- Notification System
Config.NotificationTypes = {
    success = { color = '#2ecc71', icon = 'check-circle' },
    error = { color = '#e74c3c', icon = 'times-circle' },
    info = { color = '#3498db', icon = 'info-circle' },
    warning = { color = '#f39c12', icon = 'exclamation-triangle' }
}

-- Shared Events
Config.Events = {
    PlayerLoaded = 'nexus:playerLoaded',
    JobUpdated = 'nexus:jobUpdated',
    GangUpdated = 'nexus:gangUpdated',
    InventoryUpdate = 'nexus:inventoryUpdate',
    ShowNotification = 'nexus:showNotification'
}

-- Add your shared items, jobs, vehicles tables here
Config.Items = {
    ['water'] = { name = 'water', label = 'Water', weight = 500, description = 'A bottle of water' },
    ['bread'] = { name = 'bread', label = 'Bread', weight = 300, description = 'A loaf of bread' }
    -- Add all items
}

Config.Jobs = {
    ['police'] = {
        label = 'Police Department',
        grades = {
            [0] = { name = 'recruit', label = 'Recruit', salary = 500 },
            [1] = { name = 'officer', label = 'Officer', salary = 700 },
            [2] = { name = 'sergeant', label = 'Sergeant', salary = 900 },
            [3] = { name = 'lieutenant', label = 'Lieutenant', salary = 1200 },
            [4] = { name = 'chief', label = 'Chief', salary = 1500 }
        }
    }
    -- Add all jobs
}

Config.Vehicles = {
    ['adder'] = { name = 'adder', label = 'Adder', price = 1000000, category = 'super' },
    ['fugitive'] = { name = 'fugitive', label = 'Fugitive', price = 25000, category = 'sedan' }
    -- Add all vehicles
}

return Config