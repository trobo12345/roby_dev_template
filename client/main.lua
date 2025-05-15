local ESX, QBCore = nil, nil
local PlayerData = {}

-- Keretrendszerek inicializálása
CreateThread(function()
    if Config.UseESX then
        ESX = exports["es_extended"]:getSharedObject()
        
        -- Játékos adatok lekérése spawnolásnál
        RegisterNetEvent('esx:playerLoaded')
        AddEventHandler('esx:playerLoaded', function(xPlayer)
            PlayerData = xPlayer
            print('ESX játékos betöltve:', PlayerData.job.name)
        end)
          -- Játékos adatok frissítése változáskor
        RegisterNetEvent('esx:setJob')
        AddEventHandler('esx:setJob', function(job)
            PlayerData.job = job
            print('ESX munkakör frissítve:', PlayerData.job.name)
        end)
    elseif Config.UseQBCore then
        QBCore = exports['qb-core']:GetCoreObject()
        
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
        AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
            PlayerData = QBCore.Functions.GetPlayerData()
            print('QBCore játékos betöltve:', PlayerData.job.name)
        end)
        
        RegisterNetEvent('QBCore:Client:OnJobUpdate')
        AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
            PlayerData.job = job
            print('QBCore munkakör frissítve:', PlayerData.job.name)
        end)
    elseif Config.UseStandalone then
        print('Standalone mód használata')
    end
end)

-- Példa függvény játékos adatok lekérésére különböző keretrendszerekben
function GetPlayerData()
    if Config.UseESX then
        return ESX.GetPlayerData()
    elseif Config.UseQBCore then
        return QBCore.Functions.GetPlayerData()
    else
        return {}
    end
end

-- Példa függvény játékos munkájának ellenőrzésére
function HasJob(job)
    if Config.UseESX then
        return PlayerData.job and PlayerData.job.name == job
    elseif Config.UseQBCore then
        return PlayerData.job and PlayerData.job.name == job
    else
        return false
    end
end

-- Példa az ox_lib értesítési rendszerére
function ShowNotification(message, type)
    if Config.OxLib.Notifications then
        lib.notify({
            title = 'Értesítés',
            description = message,
            type = type or 'info'
        })
    else
        -- Tartalék értesítési mód
        if Config.UseESX then
            ESX.ShowNotification(message)
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(message)
        else
            -- Natív GTA értesítés
            SetNotificationTextEntry('STRING')
            AddTextComponentString(message)
            DrawNotification(0, 1)
        end
    end
end

-- Példa az ox_lib folyamatjelzőre
function StartProgressBar(label, duration)
    if Config.OxLib.Progress then
        return lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
        })
    else
        -- Implementáld saját folyamatjelző logikádat
        Wait(duration)
        return true
    end
end

-- Példa kontextus menü létrehozására az ox_lib használatával
function OpenContextMenu()
    if Config.OxLib.ContextMenu then
        lib.registerContext({
            id = 'example_context_menu',
            title = 'Példa Menü',
            options = {
                {
                    title = 'Opció 1',
                    description = 'Ez egy példa opció',
                    onSelect = function()
                        ShowNotification('Opció 1 kiválasztva!', 'success')
                    end,
                },
                {
                    title = 'Opció 2',
                    description = 'Ez egy másik példa opció',
                    onSelect = function()
                        ShowNotification('Opció 2 kiválasztva!', 'info')
                    end,
                },
                {
                    title = 'Kilépés',
                    description = 'Kilépés a menüből',
                    icon = 'xmark'
                }
            }
        })
        lib.showContext('example_context_menu')
    else
        ShowNotification('Context menü nincs engedélyezve', 'error')
    end
end

-- Példa parancs a kontextus menü tesztelésére
RegisterCommand('testmenu', function()
    OpenContextMenu()
end, false)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, location in ipairs(Config.ExampleConfig.Locations) do
            local distance = #(playerCoords - vector3(location.x, location.y, location.z))
            
            if distance < 10.0 then
                sleep = 0
                
                -- Marker rajzolása
                DrawMarker(1, location.x, location.y, location.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 1.5 then
                    -- Segítség szöveg megjelenítése
                    lib.showTextUI('[E] - Interakció', {
                        position = "top-center",
                        icon = 'hand',
                        style = {
                            borderRadius = 0,
                            backgroundColor = '#48BB78',
                            color = 'white'
                        }
                    })
                    
                    if IsControlJustReleased(0, 38) then -- E Gomb
                        lib.hideTextUI()
                        
                        local success = StartProgressBar('Feldolgozás...', 5000)
                        
                        if success then
                            ShowNotification('Sikeres művelet!', 'success')
                            
                            TriggerServerEvent('fivem_dev_template:server:exampleEvent', location)
                        else
                            ShowNotification('Művelet megszakítva!', 'error')
                        end
                    end
                else
                    lib.hideTextUI()
                end
            end
        end
        
        Wait(sleep)
    end
end)
-- Példa export funkcióra, amelyet más scriptekből hívhatunk
exports('GetTemplateObject', function()
    return {
        HasJob = HasJob,
        ShowNotification = ShowNotification,
        StartProgressBar = StartProgressBar,
        OpenContextMenu = OpenContextMenu
    }
end)
