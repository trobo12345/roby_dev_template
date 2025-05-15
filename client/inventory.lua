-- Kliens oldali ox_inventory integrációs példák

-- Példa az ox_inventory használatára annak ellenőrzésére, hogy a játékos rendelkezik-e egy tárggyal
function HasItem(item, count)
    count = count or 1
    
    if Config.OxInventory.UseItemFunctions then
        local hasItem = exports.ox_inventory:Search('count', item) >= count
        return hasItem
    else
        -- Fallback for different frameworks
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

-- Example of opening a custom stash using ox_inventory
function OpenCustomStash(id, label)
    if Config.OxInventory.UseItemFunctions then
        exports.ox_inventory:openInventory('stash', {id = id or Config.OxInventory.CustomInventory, label = label or 'Custom Stash'})
    else
        ShowNotification('ox_inventory nem elérhető', 'error')
    end
end

-- Example command to test stash opening
RegisterCommand('teststash', function()
    OpenCustomStash()
end, false)

-- Example of using an item with a custom animation
RegisterNetEvent('roby_dev_template:client:useItem')
AddEventHandler('roby_dev_template:client:useItem', function(item)
    local playerPed = PlayerPedId()
    
    -- Cancel if player is in a vehicle
    if IsPedInAnyVehicle(playerPed, true) then
        ShowNotification('Nem használhatod ezt az eszközt járműben', 'error')
        return
    end
    
    -- Play animation
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
    
    -- Show progress bar
    local success = StartProgressBar('Tárgy használata...', 3000)
    
    -- Clear animation
    ClearPedTasks(playerPed)
    
    if success then
        ShowNotification('Sikeresen használtad: ' .. item, 'success')
        TriggerServerEvent('roby_dev_template:server:itemUsed', item)
    else
        ShowNotification('Tárgy használata megszakítva', 'error')
    end
end)

-- Example of opening a shop using ox_inventory
function OpenShop(shopName)
    if Config.OxInventory.UseItemFunctions then
        exports.ox_inventory:openInventory('shop', {type = shopName or 'General'})
    else
        ShowNotification('ox_inventory nem elérhető', 'error')
    end
end

-- Example command to test shop opening
RegisterCommand('testshop', function()
    OpenShop()
end, false)
