local npc = require('client.modules.npc')
local blipModule = require('client.modules.blip')
local utils = require('client.modules.utils')
local notification = require('client.modules.notify')
local create_showcase_vehicle = require('client.modules.showcase')
local menu_caching = require('client.modules.caching')
local menuOptions = require('client.modules.menuOptions')
local generateVehNames = require('client.modules.vehicleNames')
local mapper = require('shared.modules.configMapper')
local dprint = require('shared.modules.dprint')

local vehiclePreview = nil
local playerLoaded = false
local loadingVehicle = false

local function _spawnLocalVehicle(_shopIndex, _selected, _scrollIndex)
    local _data = Config.vehicleShops[_shopIndex]
    local _model = Config.VEHICLE_LIST[_data.VEHICLE_LIST][_selected].values[_scrollIndex].VEHICLE_MODEL

    if GetEntityModel(vehiclePreview) == _model then return end

    vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
    if loadingVehicle or vehiclePreview then return end


    loadingVehicle = true
    if not utils.loadModel(_model) then  loadingVehicle = false return end
    vehiclePreview = CreateVehicle(_model, _data.PREVIEW_COORDS.x, _data.PREVIEW_COORDS.y, _data.PREVIEW_COORDS.z, _data.PREVIEW_COORDS.w, false,false)
    utils.setVehicleProperties(vehiclePreview)
    SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
    loadingVehicle = false
end



local function proceedPayment(useBank, _shopIndex, _selected, _secondary)
    local CFG_VEH_DATA = mapper.getVehicle(_shopIndex, _selected, _secondary)
    local CFG_SHOP_DATA = mapper.getShop(_shopIndex)

	local success = lib.callback.await('lsrp_vehicleShop:server:payment', false, useBank, _shopIndex, _selected, _secondary)
    if not success then
        notification(CFG_SHOP_DATA?.SHOP_LABEL, locale('transaction_error'), 'error')
        menu_caching.showMenu(_shopIndex)
        return
    end

    if success == 'license' then
        notification(CFG_SHOP_DATA?.SHOP_LABEL, locale('license'), 'error')
        menu_caching.showMenu(_shopIndex)
        return
    end

	if success then
		local vehicleAdded, vehiclePlate, spotTaken, netId = lib.callback.await('lsrp_vehicleShop:server:addVehicle', 500, lib.getVehicleProperties(vehiclePreview), #lib.getNearbyVehicles(CFG_SHOP_DATA.PURCHASED_VEHICLE_SPAWNS.xyz, 3, true), _shopIndex, _selected, _secondary, useBank)
        if vehicleAdded then
            local data = CFG_VEH_DATA
            utils.fadeOut(500)
            if vehiclePreview then
                vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
            end

            utils.playSound('PEYOTE_COMPLETED', 'HUD_AWARDS')
            notification(CFG_SHOP_DATA?.SHOP_LABEL, locale('success_bought', CFG_VEH_DATA.label, vehiclePlate), 'success')
			Wait(1000)
            utils.teleportPlayerToLastPos()
            SetEntityVisible(cache.ped, true)
            utils.fadeIn(1000)
            notification(CFG_SHOP_DATA?.SHOP_LABEL, not spotTaken and locale('vehicle_pick_up', data.label, vehiclePlate) or locale('added_to_garage', data.label, vehiclePlate), 'success')
            npc.deleteFromVeh(NetToVeh(netId))
            return
		end

        notification(CFG_SHOP_DATA?.SHOP_LABEL, locale('error_while_saving'), 'error')
	end
end

local function openVehicleSubmenu(_shopIndex, _selected, _scrollIndex)
    local CFG_VEH_DATA = mapper.getVehicle(_shopIndex, _selected, _scrollIndex)

    local options = {}
    if ESX.PlayerData.job.grade_name == 'boss' then
        options[#options+1] = {close = false, icon = 'warehouse', label = locale('buy_for_society'), description = locale('buy_for_soc_desc'), checked = false, menuArg = 'society'}
    end

    options[#options+1] = {
        label = locale('payment'),
        icon = 'fa-solid fa-money-check-dollar',
        menuArg = 'payment',
        values = {
            {
                label = locale('cash'), 
                description = locale('pay_in_cash', CFG_VEH_DATA.VEHICLE_PRICE),
                method = 'cash'
            }, 
            {
                label = locale('bank'), 
                description = locale('pay_in_bank', CFG_VEH_DATA.VEHICLE_PRICE),
                method = 'bank'
            }
        },
    }
    
    lib.registerMenu({
        id = 'lsrp_vehicleshop:submenu1',
        title = CFG_VEH_DATA.label,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onClose = function(keyPressed)
            if lib.isTextUIOpen() then lib.hideTextUI() end
            menu_caching.showMenu(_shopIndex)
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if lib.isTextUIOpen() then lib.hideTextUI() end
        if not selected then return end
        if options[selected].menuArg == 'payment' then
            if (lib.alertDialog({
                header = Config.vehicleShops[_shopIndex].SHOP_LABEL,
                content = locale('confirm_purchase',Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_scrollIndex].label, utils.groupDigs(Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_scrollIndex].VEHICLE_PRICE)),
                centered = true,
                cancel = true,
                labels = {confirm = locale('confirm'), cancel = locale('cancel')}
            })) == 'confirm' then
                proceedPayment(options[selected].values[scrollIndex].method == 'bank', _shopIndex, _selected, _scrollIndex)
            else menu_caching.showMenu(_shopIndex) end return
        end
    end)
    lib.showMenu('lsrp_vehicleshop:submenu1')
end

local function openMenu(_shopIndex)
    utils.setLastCoords()

    local CFG_SHOP_DATA = mapper.getShop(_shopIndex)
    local CFG_VEHICLE_CLASS = Config.VEHICLE_LIST[CFG_SHOP_DATA.VEHICLE_LIST]

    lib.registerMenu({
        id = 'lsrp_vehicleshop:main',
        title = CFG_SHOP_DATA.SHOP_LABEL,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
            menu_caching.scrollCache(CFG_VEHICLE_CLASS[selected], scrollIndex)
            _spawnLocalVehicle(_shopIndex, selected, scrollIndex)
        end,
        onSelected = function(selected, scrollIndex, args)
            menu_caching.selectCache(CFG_SHOP_DATA, selected)
            _spawnLocalVehicle(_shopIndex, selected, scrollIndex)
        end,
        onClose = function(keyPressed)
            utils.fadeOut(500)
            utils.teleportPlayerToLastPos()
            vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
            Wait(500)
            SetEntityVisible(cache.ped, true)
            utils.fadeIn(1000)
            Wait(500)
        end,
        options = menuOptions.generateMenuOptions(CFG_VEHICLE_CLASS)
    }, function(selected, scrollIndex, args)
        if not selected or not scrollIndex then return end
        while not cache.vehicle and vehiclePreview do
            SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
            Wait(10)
        end

        local vehInfo = menuOptions.getVehicleInfo(vehiclePreview, CFG_VEHICLE_CLASS[selected].values[scrollIndex])
        if vehInfo then lib.showTextUI(vehInfo.text, vehInfo.options) end

        openVehicleSubmenu(_shopIndex, selected, scrollIndex)
    end)

    utils.fadeOut(500)

    SetEntityVisible(cache.ped, false)
    SetEntityCoords(cache.ped, CFG_SHOP_DATA.PREVIEW_COORDS)
    Wait(500)
    utils.fadeIn(1000)
    menu_caching.showMenu(_shopIndex)
    while not cache.vehicle do
        Wait(100)
    end
    
    notification(CFG_SHOP_DATA?.SHOP_LABEL, locale('tip'), 'tip')
end

local function onEnter(point)
    lib.showTextUI(locale('open_shop', point.shop.label or '_ERROR'), {icon = point.shop.icon or 'car', position = "top-center"})
end

local function onExit(point)
    lib.hideTextUI()
end

local function nearby(point)
    if point.currentDistance <= 2 then
        if IsControlJustPressed(0, 38) and not utils.isPlayerInShopMenu() then
            lib.hideTextUI()
            openMenu(point.shop.index)
        end
    end
end

local function createPoint(data)
	return lib.points.new(data.SHOP_COORDS, Config.textDistance, {nearby = nearby, onEnter = onEnter, onExit = onExit, shop = data.shopData})
end

local function mainThread()
    for _, shopData in pairs(Config.vehicleShops) do
        shopData.BLIP_DATA.blip = blipModule.createBlip(shopData)
    end

    while playerLoaded do
		local playerCoords = GetEntityCoords(cache.ped)

        for idx, shopData in pairs(Config.vehicleShops) do
            if #(playerCoords - shopData.SHOP_COORDS) > 200.0 then
                if shopData.point then
                    shopData.point:remove()
                    shopData.point = nil
                end
                if shopData.NPC_DATA.npc then
                    DeleteEntity(shopData.NPC_DATA.npc)
                    shopData.NPC_DATA.npc = nil
                end
                if shopData.SHOWCASE_VEHICLES then
                    for i=1, #shopData.SHOWCASE_VEHICLES do
                        if shopData.SHOWCASE_VEHICLES[i].handle then
                            while utils.deleteLocalVehicle(shopData.SHOWCASE_VEHICLES[i].handle) do
                                Wait(100)
                            end
                        end
                    end
                end

                goto continue
            end

            
            if #(playerCoords - shopData.SHOP_COORDS) < 150.0 then
                if shopData.point or shopData?.NPC_DATA?.npc then
                    goto continue
                end


                if shopData.SHOWCASE_VEHICLES and next(shopData.SHOWCASE_VEHICLES) then
                    for i=1, #shopData.SHOWCASE_VEHICLES do
                        local showcase_vehicle = shopData.SHOWCASE_VEHICLES[i]
                        if not IsModelInCdimage(showcase_vehicle.SHOWCASE_VEHICLE_MODEL) then return end
                        local modelLoaded = lib.requestModel(showcase_vehicle.SHOWCASE_VEHICLE_MODEL, 1000)
                        if not modelLoaded then return end
                        showcase_vehicle.handle = create_showcase_vehicle(showcase_vehicle, i)
                    end
                end

                shopData.NPC_DATA.npc = npc.create(shopData.NPC_DATA.model, shopData.NPC_DATA.position)

                if Config.oxTarget then
                    exports.ox_target:addLocalEntity(shopData.NPC_DATA.npc, {
                        {
                            name = 'vehicleshop',
                            icon = shopData.MENU_ICON or 'car',
                            label = locale('open_shop', shopData.SHOP_LABEL or '_ERROR'),
                            distance = 2.5,
                            onSelect = function(data)
                                openMenu(idx)
                            end
                        }
                    })
                else
                    shopData.point = createPoint({SHOP_COORDS = shopData.SHOP_COORDS, shopData = { label = shopData.SHOP_LABEL, icon = shopData.MENU_ICON, index = idx}})
                end
            end
            ::continue::
        end
        Wait(1500)
    end
end


local function onShutDown()
    playerLoaded = false

    if utils.isPlayerInShopMenu() then
        utils.teleportPlayerToLastPos()
        lib.hideMenu(false)
    end

    lib.closeAlertDialog()
    lib.hideTextUI()

    for _, shopData in pairs(Config.vehicleShops) do
        blipModule.removeBlip(shopData.BLIP_DATA.blip)
        
        if shopData.point then
            shopData.point:remove()
            shopData.point = nil
        end

        if shopData.NPC_DATA.npc then
            DeletePed(shopData.NPC_DATA.npc)
            shopData.NPC_DATA.npc = nil
        end

        if shopData.SHOWCASE_VEHICLES and next(shopData.SHOWCASE_VEHICLES) then
            for i=1, #shopData.SHOWCASE_VEHICLES do
                if shopData.SHOWCASE_VEHICLES[i].handle then
                    while utils.deleteLocalVehicle(shopData.SHOWCASE_VEHICLES[i].handle) do
                        Wait(100)
                    end
                end
            end
        end
    end

    SetEntityVisible(cache.ped, true)

    if vehiclePreview then
        vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
    end
end



--[[ Events ]]--

if ESX.IsPlayerLoaded() then
    playerLoaded = true
    CreateThread(mainThread)
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer, isNew, skin)
    if playerLoaded then
        return
    end

    playerLoaded = true
    CreateThread(mainThread)
end)


RegisterNetEvent('esx:onPlayerLogout', onShutDown)

local RES_NAME = GetCurrentResourceName()
AddEventHandler('onResourceStop', function(resourceName)
    if (RES_NAME ~= resourceName) then return end

    onShutDown()
end)


lib.onCache('vehicle', function(vehicle)
    if not vehiclePreview then
        return
    end

    if not vehicle then
        return
    end

    Wait(0)

    SetVehicleRadioEnabled(vehicle, false)
    DisplayRadar(false)
end)