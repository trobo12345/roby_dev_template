Config = {}

-- Keretrendszer felismerés
Config.UseESX = true -- Állítsd true-ra, ha ESX-et szeretnél használni
Config.UseQBCore = false -- Állítsd true-ra, ha QBCore-t szeretnél használni
Config.UseStandalone = false -- Állítsd true-ra, ha nem szeretnél keretrendszert használni

-- Discord webhook beállítások
-- MEGJEGYZÉS: A webhook URL-t érdemes szerver oldalt tárolni biztonsági okokból!
-- Ez csak egy példa konfiguráció.
Config.Discord = {
    Enabled = true,
    WebhookURL = "https://discord.com/api/webhooks/your-webhook-url-here",
    BotName = "Server Bot",
    AvatarURL = "https://i.imgur.com/example.png",
    Color = 16711680, -- Piros szín decimális formában
    FooterText = "FiveM Server",
    FooterIcon = "https://i.imgur.com/example.png"
}

-- ox_lib és ox_inventory konfiguráció
Config.OxLib = {
    Notifications = true,
    Menu = true,
    ContextMenu = true,
    Progress = true
}

Config.OxInventory = {
    UseItemFunctions = true,
    CustomInventory = "stash_example"
}

-- Példa konfiguráció szakasz
Config.ExampleConfig = {
    EnabledFeature = true,
    CooldownTime = 5000, -- ezredmásodperc
    MaxAttempts = 3,
    Locations = {
        {x = -802.87, y = 175.08, z = 72.84},
        {x = -1193.70, y = -772.50, z = 17.32},
        {x = 111.21, y = -1288.74, z = 28.85}
    },
    AllowedJobs = {
        "police",
        "ambulance",
        "mechanic"
    },
    DebugMode = false
}
