-- Szerver oldali ox_inventory integrációs példák

-- Egyedi tárgyak regisztrálása az ox_inventory-ban
if Config.OxInventory.UseItemFunctions then    -- Példa egyedi tárgy regisztrálására az erőforrás indításakor
    CreateThread(function()
        -- Várakozás az ox_inventory teljes betöltődésére
        Wait(2000)
        
        -- Ellenőrzés, hogy az ox_inventory export létezik-e
        if exports.ox_inventory then            -- Példa egy egyedi használható tárgy regisztrálására
            exports.ox_inventory:RegisterUsableItem('example_item', function(source, item, data)
                -- Kliens esemény aktiválása a tárgy használatához
                TriggerClientEvent('roby_dev_template:client:useItem', source, item.name)
            end)
            
            print('Custom items registered with ox_inventory')
        else
            print('ox_inventory export not found, custom items not registered')
        end
    end)
end
-- Példa egyedi tárgy regisztrálására
function AddItem(source, item, count, metadata)
    count = count or 1
    metadata = metadata or {}
    
    if Config.OxInventory.UseItemFunctions then
        return exports.ox_inventory:AddItem(source, item, count, metadata)
    else

        if Config.UseESX then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                return xPlayer.addInventoryItem(item, count)
            end
        elseif Config.UseQBCore then
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.AddItem(item, count, nil, metadata)
            end
        end
        return false
    end
end

-- Példa egyedi tárgy eltávolítására
function RemoveItem(source, item, count, metadata)
    count = count or 1
    metadata = metadata or {}
    
    if Config.OxInventory.UseItemFunctions then
        return exports.ox_inventory:RemoveItem(source, item, count, metadata)
    else
        if Config.UseESX then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                return xPlayer.removeInventoryItem(item, count)
            end
        elseif Config.UseQBCore then
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.RemoveItem(item, count, nil, metadata)
            end
        end
        return false
    end
end

-- Példa egyedi tárgy ellenőrzésére
function HasItem(source, item, count, metadata)
    count = count or 1
    metadata = metadata or {}
    
    if Config.OxInventory.UseItemFunctions then
        local hasItem = exports.ox_inventory:Search(source, 'count', item, metadata) >= count
        return hasItem
    else
        -- Fallback for different frameworks
        if Config.UseESX then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                local xItem = xPlayer.getInventoryItem(item)
                return xItem and xItem.count >= count
            end
        elseif Config.UseQBCore then
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                local hasItem = Player.Functions.GetItemByName(item)
                return hasItem and hasItem.amount >= count
            end
        end
        return false
    end
end

-- Példa parancs a tárgyak átadására
RegisterCommand('giveitem', function(source, args)
    -- ellenőrzés, hogy a parancsot admin indította-e
    if source == 0 or IsPlayerAceAllowed(source, 'admin') then
        local targetId = tonumber(args[1])
        local item = args[2]
        local count = tonumber(args[3]) or 1
        
        if targetId and item then
            local success = AddItem(targetId, item, count)
            
            if success then
                if source > 0 then
                    TriggerClientEvent('roby_dev_template:client:showNotification', source, 'Item sikeresen hozzáadva', 'success')
                end
                TriggerClientEvent('roby_dev_template:client:showNotification', targetId, 'Kaptál egy tárgyat: ' .. item .. ' (' .. count .. 'db)', 'success')
                
                -- Log to Discord
                SendDiscordWebhook('Item Given', 'Admin gave ' .. item .. ' (' .. count .. 'x) to player ID ' .. targetId, 'success')
            else
                if source > 0 then
                    TriggerClientEvent('roby_dev_template:client:showNotification', source, 'Nem sikerült hozzáadni a tárgyat', 'error')
                end
            end
        else
            if source > 0 then
                TriggerClientEvent('roby_dev_template:client:showNotification', source, 'Hibás parancs használat', 'error')
            end
        end
    else
        TriggerClientEvent('roby_dev_template:client:showNotification', source, 'Nincs jogosultságod ehhez a parancshoz', 'error')
    end
end, false)

-- példa egyedi tárolók létrehozására
function CreateCustomStash(id, label, slots, weight, owner)
    if Config.OxInventory.UseItemFunctions then
        return exports.ox_inventory:RegisterStash(id, label, slots, weight, owner)
    else
        return false
    end
end

-- példa egyedi tároló létrehozására
CreateThread(function()
    Wait(2000)
    
    if Config.OxInventory.UseItemFunctions and exports.ox_inventory then
        CreateCustomStash('public_stash', 'Public Stash', 50, 100000)
        
        CreateCustomStash('police_stash', 'Police Stash', 100, 200000, 'police')
        
        print('Custom stashes registered with ox_inventory')
    end
end)
