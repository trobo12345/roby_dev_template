-- Kliens oldali ox_inventory integrációs példák

-- Példa az ox_inventory használatára annak ellenőrzésére, hogy a játékos rendelkezik-e egy tárggyal
function HasItem(item, count)
    count = count or 1
    
    if Config.OxInventory.UseItemFunctions then
        local hasItem = exports.ox_inventory:Search('count', item) >= count
        return hasItem
    else
        -- Alternatív megoldás különböző keretrendszerekhez
        if Config.UseESX then
            local xPlayer = ESX.GetPlayerData()
            for _, i in ipairs(xPlayer.inventory) do
                if i.name == item and i.count >= count then
                    return true
                end
            end
        elseif Config.UseQBCore then
            local items = QBCore.Functions.GetPlayerData().items
            for _, i in pairs(items) do
                if i.name == item and i.amount >= count then
                    return true
                end
            end
        end
        return false
    end
end

-- Példa egy egyedi raktár (stash) megnyitására ox_inventory használatával
function OpenCustomStash(id, label)
    if Config.OxInventory.UseItemFunctions then
        exports.ox_inventory:openInventory('stash', {id = id or Config.OxInventory.CustomInventory, label = label or 'Egyedi raktár'})
    else
        ShowNotification('ox_inventory nem elérhető', 'error')
    end
end

-- Parancs példa a raktár megnyitásának tesztelésére
RegisterCommand('teststash', function()
    OpenCustomStash()
end, false)

-- Példa egy tárgy használatára egyedi animációval
RegisterNetEvent('roby_dev_template:client:useItem')
AddEventHandler('roby_dev_template:client:useItem', function(item)
    local playerPed = PlayerPedId()
    
    -- Megszakítás, ha a játékos járműben van
    if IsPedInAnyVehicle(playerPed, true) then
        ShowNotification('Nem használhatod ezt az eszközt járműben', 'error')
        return
    end
    
    -- Animáció lejátszása
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
    
    -- Folyamatjelző sáv megjelenítése
    local success = StartProgressBar('Tárgy használata...', 3000)
    
    -- Animáció törlése
    ClearPedTasks(playerPed)
    
    if success then
        ShowNotification('Sikeresen használtad: ' .. item, 'success')
        TriggerServerEvent('roby_dev_template:server:itemUsed', item)
    else
        ShowNotification('Tárgy használata megszakítva', 'error')
    end
end)

-- Példa bolt megnyitására ox_inventory használatával
function OpenShop(shopName)
    if Config.OxInventory.UseItemFunctions then
        exports.ox_inventory:openInventory('shop', {type = shopName or 'General'})
    else
        ShowNotification('ox_inventory nem elérhető', 'error')
    end
end

-- Parancs példa a bolt megnyitásának tesztelésére
RegisterCommand('testshop', function()
    OpenShop()
end, false)
