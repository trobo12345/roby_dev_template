local ESX, QBCore = nil, nil

-- Initialize frameworks
if Config.UseESX then
    ESX = exports["es_extended"]:getSharedObject()
    print('ESX keretrendszer betöltve (szerver)')
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
    print('QBCore keretrendszer betöltve (szerver)')
else
    print('Standalone mód használata (szerver)')
end

-- Példa függvény játékos lekérésére azonosító alapján különböző keretrendszerekben
function GetPlayer(source)
    if Config.UseESX then
        return ESX.GetPlayerFromId(source)
    elseif Config.UseQBCore then
        return QBCore.Functions.GetPlayer(source)
    else
        -- Implementáld saját játékos lekérési logikádat standalone módban
        return nil
    end
end

-- Példa függvény pénz küldésére a játékosnak különböző keretrendszerekben
function AddMoney(source, amount, type, reason)
    type = type or 'bank'
    reason = reason or 'Sablon erőforrás kifizetés'
    local player = GetPlayer(source)
    
    if player then
        if Config.UseESX then
            player.addAccountMoney(type, amount)
            return true
        elseif Config.UseQBCore then
            player.Functions.AddMoney(type, amount, reason)
            return true
        else
            -- Implementáld saját pénz hozzáadási függvényedet standalone módban
            return false
        end
    end
    return false
end

-- Példa függvény annak ellenőrzésére, hogy a játékosnak van-e adott munkája
function HasJob(source, job, grade)
    local player = GetPlayer(source)
    
    if player then
        if Config.UseESX then
            if grade then
                return player.job.name == job and player.job.grade >= grade
            else
                return player.job.name == job
            end
        elseif Config.UseQBCore then
            if grade then
                return player.PlayerData.job.name == job and player.PlayerData.job.grade.level >= grade
            else
                return player.PlayerData.job.name == job
            end
        else
            -- Implementáld saját munka ellenőrzési logikádat standalone módban
            return false
        end
    end
    return false
end

-- Példa szerver oldali eseménykezelő
RegisterServerEvent('roby_dev_template:server:exampleEvent')
AddEventHandler('roby_dev_template:server:exampleEvent', function(data)
    local src = source
    local player = GetPlayer(src)
    
    if not player then
        -- Handle case where player is not found
        return
    end
    
    -- Példa munka ellenőrzés
    if not HasJob(src, 'police') then
        -- Send client notification
        TriggerClientEvent('roby_dev_template:client:showNotification', src, 'Nincs megfelelő jogosultságod', 'error')
        return
    end
    
    -- Példa pénz hozzáadás
    local success = AddMoney(src, 1000, 'bank', 'Template jutalom')
    
    if success then
        TriggerClientEvent('roby_dev_template:client:showNotification', src, '1000$ jóváírva a bankszámládon', 'success')
        
        SendDiscordWebhook('Player Reward', 'A player received a reward of $1000', 'success')
    else
        TriggerClientEvent('roby_dev_template:client:showNotification', src, 'Hiba történt a pénz hozzáadásakor', 'error')
    end
end)

-- Példa a tárgy használat eseményre az ox_inventory-ból
RegisterServerEvent('roby_dev_template:server:itemUsed')
AddEventHandler('roby_dev_template:server:itemUsed', function(item)
    local src = source
    local player = GetPlayer(src)
    
    if player then
        -- Példa a tárgy használat naplózására
        print('Player ' .. src .. ' used ' .. item)
        
        -- Példa webhook küldésre
        SendDiscordWebhook('Item Used', 'Player ID ' .. src .. ' used ' .. item, 'info')
    end
end)

-- Példa adatbázis lekérdezésre oxmysql használatával
function FetchPlayerData(identifier)
    if not identifier then return nil end
    
    local promise = promise.new()
    
    MySQL.Async.fetchAll('SELECT * FROM players WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result and result[1] then
            promise:resolve(result[1])
        else
            promise:resolve(nil)
        end
    end)
    
    return Await(promise)
end

-- Példa parancs az adatbázis lekérdezés tesztelésére
RegisterCommand('testdb', function(source, args)
    local src = source
    local player = GetPlayer(src)
    
    if player then
        local identifier
        
        if Config.UseESX then
            identifier = player.identifier
        elseif Config.UseQBCore then
            identifier = player.PlayerData.license
        else
            -- Use a placeholder identifier for standalone mode
            identifier = GetPlayerIdentifierByType(src, 'license')
        end
        
        local data = FetchPlayerData(identifier)
        
        if data then
            TriggerClientEvent('roby_dev_template:client:showNotification', src, 'Adatok lekérdezve az adatbázisból', 'success')
        else
            TriggerClientEvent('roby_dev_template:client:showNotification', src, 'Nem található adat az adatbázisban', 'error')
        end
    end
end, false)

-- Discord webhook funkció
function SendDiscordWebhook(title, message, type)
    if not Config.Discord.Enabled or not Config.Discord.WebhookURL then return end
    
    -- Típus konvertálása színné
    local color
    if type == 'success' then
        color = 65280 -- Green
    elseif type == 'error' then
        color = 16711680 -- Red
    elseif type == 'warning' then
        color = 16776960 -- Yellow
    else
        color = Config.Discord.Color 
    end
      -- Beágyazás tábla létrehozása
    local embeds = {
        {
            ["title"] = title,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = Config.Discord.FooterText,
                ["icon_url"] = Config.Discord.FooterIcon
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }
    
    -- Webhook küldése
    PerformHttpRequest(Config.Discord.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Discord.BotName,
        embeds = embeds,
        avatar_url = Config.Discord.AvatarURL
    }), { ['Content-Type'] = 'application/json' })
end

CreateThread(function()
    while true do
        Wait(3600000)
        
        print('Hourly task executed at: ' .. os.date('%Y-%m-%d %H:%M:%S'))
        
        SendDiscordWebhook('Scheduled Task', 'Hourly maintenance task completed', 'info')
    end
end)

exports('GetTemplateObject', function()
    return {
        GetPlayer = GetPlayer,
        AddMoney = AddMoney,
        HasJob = HasJob,
        SendDiscordWebhook = SendDiscordWebhook
    }
end)
