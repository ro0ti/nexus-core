fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'NexusCore'
author 'github.com/ro0ti'
description 'Advanced FiveM Roleplay Framework'
version '1.1.0'

shared_scripts {
    'config.lua',
    'shared/functions.lua',
    'shared/events.lua',
    'shared/enums.lua',
    'shared/callbacks.lua',
    'shared/logger.lua',
    'locales/en.lua',
    'locales/es.lua',
    'shared/jobs.lua',
    'shared/gangs.lua',
    'shared/items.lua',
    'shared/vehicles.lua' -- Added missing shared vehicles
}

client_scripts {
    -- Core
    'client/main.lua',
    'client/players.lua',
    'client/events.lua',
    'client/ui.lua',
    
    -- Inventory System
    'client/inventory.lua',
    'client/inventory/ui.lua',
    'client/inventory/drops.lua', -- Added missing
    
    -- Job System
    'client/jobs.lua',
    'client/jobs/duty.lua',
    'client/jobs/blips.lua',
    
    -- Gang System
    'client/gangs.lua',
    'client/gangs/territory.lua',
    'client/gangs/menus.lua',
    
    -- Drug System
    'client/drugs.lua',
    'client/drugs/effects.lua',
    'client/drugs/markets.lua',
    
    -- Vehicle System
    'client/vehicles.lua',
    'client/vehicles/keys.lua',
    'client/vehicles/hotwire.lua',
    'client/vehicles/repair.lua', -- Added missing
    
    -- Garage System
    'client/garages.lua',
    'client/garages/markers.lua',
    'client/garages/menus.lua',
    
    -- Shop System
    'client/shops.lua',
    'client/shops/robbery.lua',
    'client/shops/registers.lua',
    
    -- Phone System
    'client/phone/apps.lua',
    'client/phone/camera.lua',
    'client/phone/contacts.lua',
    'client/phone/notifications.lua', -- Added missing
    
    -- Housing System
    'client/housing/entry.lua',
    'client/housing/furniture.lua',
    'client/housing/wardrobe.lua',
    'client/housing/keys.lua', -- Added missing
    
    -- Clothing System
    'client/clothing/shops.lua',
    'client/clothing/changing.lua',
    'client/clothing/outfits.lua',
    
    -- Security System
    'client/security/validation.lua',
    'client/security/checks.lua',
    'client/security/commands.lua', -- Added missing
    
    -- Developer Tools
    'client/dev/debug.lua',
    'client/dev/coords.lua',
    
    -- API Integrations
    'client/api/voice.lua',
    'client/api/discord.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- Core
    'server/main.lua',
    'server/players.lua',
    'server/events.lua',
    'server/database.lua',
    'server/commands.lua',
    
    -- Admin System
    'server/admin.lua',
    'server/admin/commands.lua',
    'server/admin/logs.lua',
    
    -- Inventory System
    'server/inventory.lua',
    'server/inventory/items.lua',
    'server/inventory/drops.lua',
    'server/inventory/crafting.lua', -- Added missing
    
    -- Job System
    'server/jobs.lua',
    'server/jobs/paycheck.lua',
    'server/jobs/boss.lua',
    
    -- Gang System
    'server/gangs.lua',
    'server/gangs/warehouses.lua',
    'server/gangs/territories.lua',
    
    -- Drug System
    'server/drugs.lua',
    'server/drugs/markets.lua',
    'server/drugs/processing.lua',
    
    -- Vehicle System
    'server/vehicles.lua',
    'server/vehicles/owned.lua',
    'server/vehicles/garages.lua',
    'server/vehicles/states.lua', -- Added missing
    
    -- Garage System
    'server/garages.lua',
    'server/garages/impound.lua',
    'server/garages/parking.lua',
    
    -- Shop System
    'server/shops.lua',
    'server/shops/restock.lua',
    'server/shops/register.lua',
    
    -- Phone System
    'server/phone/contacts.lua',
    'server/phone/messages.lua',
    'server/phone/calls.lua',
    'server/phone/backgrounds.lua', -- Added missing
    
    -- Housing System
    'server/housing/owned.lua',
    'server/housing/transactions.lua',
    'server/housing/storage.lua',
    'server/housing/keys.lua', -- Added missing
    
    -- Clothing System
    'server/clothing/outfits.lua',
    'server/clothing/shops.lua',
    
    -- Security System
    'server/security/anticheat.lua',
    'server/security/logs.lua',
    'server/security/commands.lua', -- Added missing
    
    -- Developer Tools
    'server/dev/reports.lua',
    'server/dev/commands.lua',
    
    -- API Integrations
    'server/api/discord.lua',
    'server/api/screenshot.lua',
    
    -- Database Setup
    'sql/setup.sql',
    'sql/items.sql',
    'sql/vehicles.sql',
    'sql/houses.sql' -- Added missing
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/images/*.png',
    'html/images/*.jpg',
    'html/fonts/*.ttf',
    'html/sounds/*.ogg',
    'html/phone/*.html', -- Added missing phone HTML
    'html/phone/css/*.css', -- Added missing
    'html/phone/js/*.js', -- Added missing
    
    -- Streamed Assets
    'stream/*.ytyp',
    'stream/*.ydr',
    'stream/*.ytd',
    'stream/vehicles/*.y*' -- Added missing vehicle assets
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'
data_file 'VEHICLE_METADATA_FILE' 'stream/vehicles/*.meta' -- Added missing

escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'client/dev/*.lua',
    'server/dev/*.lua',
    'sql/*.sql',
    'html/**/*' -- Added HTML files to escrow ignore
}

dependencies {
    'oxmysql',
    'pma-voice',
    'discord-screenshot',
    'fivem-appearance' -- Added missing dependency
}

provide 'qb-core'
provide 'es_extended' -- Added compatibility