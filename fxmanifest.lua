fx_version 'cerulean'
game 'gta5'

name 'FiveM Developer Template'
description 'Fejlesztői sablon ESX, QBCore és Standalone integrációval, Discord webhook és ox library példákkal'
author 'Roby'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    -- '@qb-core/shared/locale.lua',
    -- '@qb-core/shared/vehicles.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'oxmysql',
    'ox_lib',
    'ox_inventory'
}
