local RSGCore = exports['rsg-core']:GetCoreObject()
local currentvendor = nil

-------------------------------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------------------------------

-- main menu system
RegisterNetEvent('rsg-vendor:client:vendorMenu', function()
    RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorOwned', function(result)
        if result == nil then
            lib.registerContext({
                id = 'buy_menu',
                title = 'Buy Market Stall',
                options = {
                    {
                        title = 'Buy Market Stall',
                        description = Lang:t('menu.buy_sub').." : $" ..string.format("%.2f", Config.Market[currentvendor].price),
                        icon = 'fa-solid fa-file-invoice-dollar',
                        serverEvent = 'rsg-vendor:server:vendorBuyStall',
                        args = { location = currentvendor, price = Config.Market[currentvendor].price  },
                        arrow = true
                    }
                }
            })
            lib.showContext("buy_menu")
        else
            RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorOwner', function(result2)
                if result2 == nil then
                    lib.registerContext({
                        id = 'market_menu',
                        title = 'Market Menu',
                        options = {
                            {
                                title = Lang:t('menu.open_market'),
                                description = Lang:t('menu.open_market_sub'),
                                icon = 'fa-solid fa-store',
                                serverEvent = 'rsg-vendor:server:vendorGetShopItems',
                                args = { location = currentvendor  },
                                arrow = true
                            },
                            {
                                title = Lang:t('menu.rob'),
                                description = Lang:t('menu.rob_sub'),
                                icon = 'fa-solid fa-gun',
                                event = 'rsg-vendor:client:vendorRob',
                                args = { location = currentvendor  },
                                arrow = true
                            },
                        }
                    })
                    lib.showContext("market_menu")
                else
                    lib.registerContext({
                        id = 'owner_menu',
                        title = 'Owner Menu',
                        options = {
                            {
                                title = Lang:t('menu.open_market'),
                                description = Lang:t('menu.open_market_sub'),
                                icon = 'fa-solid fa-store',
                                serverEvent = 'rsg-vendor:server:vendorGetShopItems',
                                args = { location = currentvendor  },
                                arrow = true
                            },
                            {
                                title = Lang:t('menu.refill'),
                                description = Lang:t('menu.refill_sub'),
                                icon = 'fa-solid fa-boxes-packing',
                                event = 'rsg-vendor:client:vendorInvReFull',
                                args = { },
                                arrow = true
                            },
                            {
                                title = Lang:t('menu.checkmoney'),
                                description = Lang:t('menu.checkmoney_sub'),
                                icon = 'fa-solid fa-sack-dollar',
                                event = 'rsg-vendor:client:vendorCheckMoney',
                                args = { },
                                arrow = true
                            },
                            {
                                title = Lang:t('menu.manage'),
                                description = Lang:t('menu.manage_sub'),
                                icon = 'fa-solid fa-sack-dollar',
                                event = 'rsg-vendor:client:vendorSettings',
                                args = { },
                                arrow = true
                            },
                        }
                    })
                    lib.showContext("owner_menu")
                end
            end, currentvendor)
        end
    end, currentvendor)
end)

-- stall inventory
RegisterNetEvent("rsg-vendor:client:vendorInv", function(store_inventory, data)
    RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorS', function(result)
        local options = {}
        for k, v in ipairs(store_inventory) do
            if store_inventory[k].stock > 0 then
                options[#options + 1] = {
                    title = RSGCore.Shared.Items[store_inventory[k].items].label,
                    description = 'Stock: '..store_inventory[k].stock..' | '..Lang:t('menu.price')..string.format("%.2f", store_inventory[k].price),
                    icon = 'fa-solid fa-box',
                    event = 'rsg-vendor:client:vendorInvInput',
                    args = store_inventory[k],
                    arrow = true,
                }
            else
                RSGCore.Functions.Notify("Stall Empty!", 'error')
                return
            end
        end
        lib.registerContext({
            id = 'shopinv_menu',
            title = "Shop Menu",
            position = 'top-right',
            menu = 'owner_menu',
            onBack = function() end,
            options = options
        })
        lib.showContext('shopinv_menu')
    end, currentvendor)
end)

-- owners refill stall
RegisterNetEvent("rsg-vendor:client:vendorInvReFull", function()
    RSGCore.Functions.GetPlayerData(function(PlayerData)
        RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorS', function(result)
            if PlayerData.items == nil then
                lib.registerContext({
                    id = 'no_inventory',
                    title = 'Market Stall',
                    menu = 'owner_menu',
                    onBack = function() end,
                    options = {
                        {
                            title = Lang:t('menu.market').." : "..result[1].displayname,
                            description = Lang:t('menu.no_item_sub'),
                            icon = 'fa-solid fa-file-invoice-dollar',
                            arrow = false
                        }
                    }
                })
                lib.showContext("no_inventory")
            else
                local options = {}
                for k, v in ipairs(PlayerData.items) do
                    options[#options + 1] = {
                        title = PlayerData.items[k].label,
                        description = 'inventory amount : '..PlayerData.items[k].amount,
                        icon = 'fa-solid fa-box',
                        event = 'rsg-vendor:client:vendorInvReFillInput',
                        args = PlayerData.items[k],
                        arrow = true,
                    }
                end
                lib.registerContext({
                    id = 'inv_menu',
                    title = "Shop Inventory",
                    position = 'top-right',
                    menu = 'owner_menu',
                    onBack = function() end,
                    options = options
                })
            lib.showContext('inv_menu')
            end
        end, currentvendor)
    end)
end)

-- owner money menu
RegisterNetEvent("rsg-vendor:client:vendorCheckMoney", function()
    RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorGetMoney', function(checkmoney)
        RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorS', function(result)
            lib.registerContext({
                id = 'money_menu',
                title = 'Balance : $' ..string.format("%.2f", checkmoney.money),
                menu = 'owner_menu',
                onBack = function() end,
                options = {
                    {
                        title = Lang:t('menu.withdraw'),
                        description = Lang:t('menu.withdraw_sub'),
                        icon = 'fa-solid fa-money-bill-transfer',
                        event = 'rsg-vendor:client:vendorWithdraw',
                        args = checkmoney,
                        arrow = true
                    },
                }
            })
            lib.showContext("money_menu")
        end, currentvendor)
    end, currentvendor)
end)

-- owner settings menu
RegisterNetEvent('rsg-vendor:client:vendorSettings', function()
    RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorS', function(result)
        lib.registerContext({
            id = 'settings_menu',
            title = Lang:t('menu.market')..' : ' ..result[1].displayname,
            menu = 'owner_menu',
            onBack = function() end,
            options = {
                {
                    title = Lang:t('menu.manage_in_name'),
                    description = Lang:t('menu.manage_in_name_sub'),
                    icon = 'fa-solid fa-file-signature',
                    event = 'rsg-vendor:client:vendorName',
                    arrow = true
                },
                {
                    title = Lang:t('menu.manage_in_give_market'),
                    description = Lang:t('menu.manage_in_give_market_sub'),
                    icon = 'fa-solid fa-handshake',
                    event = 'rsg-vendor:client:vendorGiveBusiness',
                    arrow = true
                },
            }
        })
        lib.showContext("settings_menu")
    end, currentvendor)
end)

-------------------------------------------------------------------------------------------
-- Input
-------------------------------------------------------------------------------------------

-- change owner
RegisterNetEvent('rsg-vendor:client:vendorGiveBusiness', function()
    local input = lib.inputDialog(Lang:t('input.give_market'), {
        { 
            label = Lang:t('input.give_market_champ'),
            type = 'input',
            required = true,
        },
    })
    
    if not input then
        return
    end

    TriggerServerEvent('rsg-vendor:server:vendorGiveBusiness', currentvendor, input[1])

end)

-- change name
RegisterNetEvent('rsg-vendor:client:vendorName', function()
    local input = lib.inputDialog(Lang:t('input.name'), {
        { 
            label = Lang:t('input.name_champ'),
            type = 'input',
            required = true,
        },
    })
    
    if not input then
        return
    end

    TriggerServerEvent('rsg-vendor:server:vendorName', currentvendor, input[1])

end)

-- vendor withdraw
RegisterNetEvent('rsg-vendor:client:vendorWithdraw', function(checkmoney)
    local money = checkmoney.money
    local input = lib.inputDialog('Max Withdraw: $'..string.format("%.2f", money), {
        { 
            label = Lang:t('input.withdraw_champ'),
            type = 'input',
            required = true,
            icon = 'fa-solid fa-dollar-sign'
        },
    })
    
    if not input then
        return
    end
    
    if tonumber(input[1]) == nil then
        return
    end

    if money >= tonumber(input[1]) then
        TriggerServerEvent('rsg-vendor:server:vendorWithdraw', currentvendor, tonumber(input[1]))
    else
        RSGCore.Functions.Notify(("Invalid Amount"), 'error')
    end
end)

-- vendor add items from inventory
RegisterNetEvent('rsg-vendor:client:vendorInvReFillInput', function(data)
    local name = data
    local label = data.label
    local amount = data.amount
    local input = lib.inputDialog(Lang:t('input.refill').." : "..label, {
        { 
            label = Lang:t('input.qt'),
            description = 'must have the amount in your inventory',
            type = 'number',
            required = true,
            icon = 'hashtag'
        },
        { 
            label = Lang:t('input.refill_price'),
            description = 'example: 0.10',
            default = '0.10',
            type = 'input',
            required = true,
            icon = 'fa-solid fa-dollar-sign'
        },
    })
    
    if not input then
        return
    end
    
    RSGCore.Functions.GetPlayerData(function(PlayerData)
        for k, v in pairs(PlayerData.items) do
            if amount >= tonumber(input[1]) and tonumber(input[2]) ~= nil then
                TriggerServerEvent('rsg-vendor:server:vendorInvReFill', currentvendor, name, input[1], tonumber(input[2]))
            else
                RSGCore.Functions.Notify('Something went wrong, check you have the correct amount and price!', 'error')
            end
            return
        end
    end)
end)

-- buy vendor items
RegisterNetEvent('rsg-vendor:client:vendorInvInput', function(data)
    local name = data.items
    local price = data.price
    local stock = data.stock
    local input = lib.inputDialog(RSGCore.Shared.Items[name].label.." | $"..string.format("%.2f", price).." | Stock: "..stock, {
        { 
            label = Lang:t('input.qt'),
            type = 'number',
            required = true,
            icon = 'hashtag'
        },
    })
    
    if not input then
        return
    end
    
    if stock >= tonumber(input[1]) then
        TriggerServerEvent('rsg-vendor:server:vendorPurchaseItem', currentvendor, name, input[1])
    else
        RSGCore.Functions.Notify(("Invalid Amount"), 'error')
    end
end)

-------------------------------------------------------------------------------------------
-- Event
-------------------------------------------------------------------------------------------

RegisterNetEvent("Stores:ReturnStoreItems")
AddEventHandler("Stores:ReturnStoreItems", function(data2, data3)
    store_inventory = data2
    Wait(100)
    TriggerEvent('rsg-vendor:client:vendorInv', store_inventory, data3)
end)

-------------------------------------------------------------------------------------------
-- NPC
-------------------------------------------------------------------------------------------

function SET_PED_RELATIONSHIP_GROUP_HASH ( iVar0, iParam0 )
    return Citizen.InvokeNative( 0xC80A74AC829DDD92, iVar0, _GET_DEFAULT_RELATIONSHIP_GROUP_HASH( iParam0 ) )
end

function _GET_DEFAULT_RELATIONSHIP_GROUP_HASH ( iParam0 )
    return Citizen.InvokeNative( 0x3CC4A718C258BDD0 , iParam0 );
end

function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

function RandomPed ()
    return Config.Model[math.random(1, #Config.Model)]
end

local peds = {}
Citizen.CreateThread(function()
    for z, x in pairs(Config.Market) do
        peds[z] = _CreatePed(Config.Market[z].npc, Config.Market[z].heading)
        --print(peds)
    end
end)

function _CreatePed(coords, heading)
    local ped = RandomPed()
    while not HasModelLoaded( GetHashKey(ped) ) do
        Wait(500)
        modelrequest( GetHashKey(ped) )
    end

    local npc = CreatePed(GetHashKey(ped), coords, heading, false, false, 0, 0)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    ClearPedTasks(npc)
    RemoveAllPedWeapons(npc)
    SET_PED_RELATIONSHIP_GROUP_HASH(npc, GetHashKey(ped))
    SetEntityCanBeDamagedByRelationshipGroup(npc, false, `PLAYER`)
    SetEntityAsMissionEntity(npc, true, true)
    SetModelAsNoLongerNeeded(GetHashKey(ped))
    SetBlockingOfNonTemporaryEvents(npc,true)
    ClearPedTasksImmediately(npc)
    FreezeEntityPosition(npc, false)
    Wait(1000)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    TaskStandStill(npc, -1)
    return npc
end

-------------------------------------------------------------------------------------------
-- ROBBERY
-------------------------------------------------------------------------------------------

RegisterNetEvent("rsg-vendor:client:vendorRob", function()
    local me = PlayerPedId()
    local isArmed = Citizen.InvokeNative(0xCB690F680A3EA971, me, 4)  --isPedArmed
    if isArmed then
        RSGCore.Functions.TriggerCallback('rsg-vendor:server:vendorS', function(result)
            if result[1].robbery == 0 then
                for i, x in pairs(peds) do
                    if HasEntityClearLosToEntityInFront(me, peds[i], 19) and not IsPedDeadOrDying(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 4.0 then
                        --print("Ok")
                        local pedcoord = GetEntityCoords(peds[i])
                        local pedheading = GetEntityHeading(peds[i])
                        local randomNumber = math.random(1,10)
                        --print(randomNumber)
                        Wait(100)
                        if randomNumber <= Config.ChanceFail then
                            GiveWeaponToPed_2(peds[i], 0x5B78B8DD, 90, true, true, GetWeapontypeGroup(0x5B78B8DD), true, 0.5, 1.0, 0, true, 0, 0)
                            SetCurrentPedWeapon(peds[i], 0x5B78B8DD, true)
                            Wait(100)
                            SetEntityInvincible(peds[i], false)
                            FreezeEntityPosition(peds[i], false)
                            SetEntityCanBeDamagedByRelationshipGroup(peds[i], true, `PLAYER`)
                            SetBlockingOfNonTemporaryEvents(peds[i],false)
                            TaskCombatPed(peds[i], PlayerPedId(), 0, 16)
                            Wait(100)
                            RSGCore.Functions.Notify(Lang:t('rob.fail'), 'error')
                            Wait(20000)
                            DeletePed(peds[i])
                            Wait(10000)
                            newpeds = _CreatePed(pedcoord, pedheading)
                            table.insert(peds, newpeds)
                        else
                            RequestAnimDict("script_proc@robberies@homestead@lonnies_shack@deception")
                            while not HasAnimDictLoaded("script_proc@robberies@homestead@lonnies_shack@deception") do
                                Citizen.Wait(100)
                            end
                            TaskPlayAnim(peds[i], "script_proc@robberies@homestead@lonnies_shack@deception", "hands_up_loop", 2.0, -2.0, -1, 67109393, 0.0, false, 1245184, false, "UpperbodyFixup_filter", false)

                            RSGCore.Functions.Progressbar("robbery", Lang:t('rob.good'), Config.RobTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                            end)
                            Wait(Config.RobTime)
                            ClearPedTasks(peds[i])
                            TriggerServerEvent("rsg-vendor:server:vendorRob", currentvendor)
                        end
                    end
                end
            else
                RSGCore.Functions.Notify(Lang:t('rob.already'), 'error')
            end
        end, currentvendor)
    else
        RSGCore.Functions.Notify(Lang:t('rob.need_gun'), 'error')
    end
end)

-------------------------------------------------------------------------------------------
-- Blips
-------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    for z, x in pairs(Config.Market) do
        local blip = N_0x554d9d53f696d002(1664425300, Config.Market[z].coords)
        SetBlipSprite(blip, Config.MarketShop, 1)
        SetBlipScale(blip, 0.025)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, Lang:t('other.blips'))
    end  
end)

-------------------------------------------------------------------------------------------
-- Prompt
-------------------------------------------------------------------------------------------

CreateThread(function()
    for k, v in pairs(Config.Market) do
        exports['rsg-core']:createPrompt(Config.Market[k], Config.Market[k].coords, 0xF3830D8E, Lang:t('other.prompt'), {
            type = 'client',
            event = 'rsg-vendor:client:vendorMenuPrompt'
        })
    end
end)

RegisterNetEvent('rsg-vendor:client:vendorMenuPrompt', function()
    for k, v in pairs(Config.Market) do
        local PutOutDist = #(GetEntityCoords(PlayerPedId()) - Config.Market[k].coords)
        if PutOutDist <= 4 then
            if not IsPedInAnyVehicle(PlayerPedId()) then
                currentvendor = k
                TriggerEvent('rsg-vendor:client:vendorMenu')
            end
        end
    end
end)

-------------------------------------------------------------------------------------------
-- Debug
-------------------------------------------------------------------------------------------
--[[
RegisterNetEvent("rsg-vendor:server:vendorDbInv")
AddEventHandler("rsg-vendor:server:vendorDbInv", function()
    RSGCore.Functions.GetPlayerData(function(PlayerData)
        for k, v in pairs(PlayerData.items) do 
            if PlayerData.items[k] ~= nil and PlayerData.items[k].type == "item" then 
                print(PlayerData.items[k].name.." - "..PlayerData.items[k].amount)
            end
        end
    end)
end)

RegisterCommand('debug_inv', function()
    TriggerEvent("rsg-vendor:server:vendorDbInv")
end)

RegisterCommand('debug_input', function()
    TriggerEvent("rsg-vendor:client:vendorName")
end)
]]--
