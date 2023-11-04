local npc = require('client.modules.npc')
local blipModule = require('client.modules.blip')
local utils = require('client.modules.utils')
local notification = require('client.modules.notify')
local create_showcase_vehicle = require('client.modules.showcase')
local menu_caching = require('client.modules.caching')
local menuOptions = require('client.modules.menuOptions')
local generateVehNames = require('client.modules.vehicleNames')


local vehiclePreview = nil
local playerLoaded = false
local IS_PLAYER_IN_SHOP = false
local shopPoint = {}
local lastIndex = nil
local loadingVehicle = false
local vehicleInvData = {}

local function _spawnLocalVehicle(_shopIndex, _selected, _scrollIndex)
    vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
    if loadingVehicle or vehiclePreview then return end

    local _data = Config.vehicleShops[_shopIndex]
    local _model = Config.VEHICLE_LIST[_data.VEHICLE_LIST][_selected].values[_scrollIndex].VEHICLE_MODEL
    loadingVehicle = true
    if not utils.loadModel(_model) then 
        loadingVehicle = false
        return 
    end
    vehiclePreview = CreateVehicle(_model, _data.PREVIEW_COORDS.x, _data.PREVIEW_COORDS.y, _data.PREVIEW_COORDS.z, _data.PREVIEW_COORDS.w, false,false)
    utils.setVehicleProperties(vehiclePreview)
    SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
    loadingVehicle = false
end



local function proceedPayment(useBank, _shopIndex, _selected, _secondary)
    if not useBank then
        local count = _inv:Search('count', 'money')
        if count < Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_secondary].VEHICLE_PRICE then
            notification(Config.vehicleShops[_shopIndex]?.SHOP_LABEL, locale('not_enough_money', Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_secondary].VEHICLE_PRICE), 'error')
            menu_caching.showMenu(_shopIndex)
            return
        end
    end

	local success = lib.callback.await('lsrp_vehicleShop:server:payment', false, useBank, _shopIndex, _selected, _secondary)
    if not success then
        notification(Config.vehicleShops[_shopIndex]?.SHOP_LABEL or '[_ERROR_]', locale('transaction_error'), 'error')
        menu_caching.showMenu(_shopIndex)
        return
    end

    if success == 'license' then
        notification(Config.vehicleShops[_shopIndex]?.SHOP_LABEL or '[_ERROR_]', locale('license'), 'error')
        menu_caching.showMenu(_shopIndex)
        return
    end

	if success then
		local vehicleAdded, vehiclePlate, spotTaken, netId = lib.callback.await('lsrp_vehicleShop:server:addVehicle', 500, lib.getVehicleProperties(vehiclePreview), #lib.getNearbyVehicles(Config.vehicleShops[_shopIndex].vehicleSpawnCoords.xyz, 3, true), _shopIndex, _selected, _secondary, useBank)
        if vehicleAdded then
            local data = Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_secondary]
            utils.fadeOut(500)
            if vehiclePreview then
                vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
            end
			PlaySoundFrontend(-1, 'Pre_Screen_Stinger', 'DLC_HEISTS_FAILED_SCREEN_SOUNDS', 0)
            notification(Config.vehicleShops[_shopIndex]?.SHOP_LABEL, locale('success_bought', Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_secondary].label, vehiclePlate), 'success')
			Wait(1000)
            utils.teleportPlayerToLastPos()
            SetEntityVisible(cache.ped, true)
            utils.fadeIn(1000)
            notification(Config.vehicleShops[_shopIndex]?.SHOP_LABEL or '[_ERROR_]', not spotTaken and locale('vehicle_pick_up', data.label, vehiclePlate) or locale('added_to_garage', data.label, vehiclePlate), 'success')
            npc.deleteFromVeh(NetToVeh(netId))
            return
		end

        notification(Config.vehicleShops[_shopIndex]?.SHOP_LABEL or '[_ERROR_]', locale('error_while_saving'), 'error')
	end
end

local function openVehicleSubmenu(_shopIndex, _selected, _scrollIndex)
    local subMenu = {_shopIndex, _selected, _scrollIndex}
    local vData = Config.VEHICLE_LIST[Config.vehicleShops[subMenu[1]].VEHICLE_LIST][subMenu[2]].values[subMenu[3]]
    local vClass = GetVehicleClass(vehiclePreview)
    local options = {}

    if Config.vehicleColors.primary == true then
        options[#options+1] = {close = false, icon = 'droplet', label = locale('primary_color'), description = locale('primary_color_desc'), menuArg = 'primary'}
    end
    
    if Config.vehicleColors.secondary == true then
        options[#options+1] = {close = false, icon = 'fill-drip', label = locale('secondary_color'), description = locale('secondary_color_desc'), menuArg = 'secondary'}
    end

    if ESX.PlayerData.job.grade_name == 'boss' then
        options[#options+1] = {close = false, icon = 'warehouse', label = locale('buy_for_society'), description = locale('buy_for_soc_desc'), checked = false, menuArg = 'society'}
    end

    options[#options+1] = {
        label = 'Platba',
        icon = 'credit-card',
        menuArg = 'payment',
        values = {
            {
                label = locale('cash'), 
                description = locale('pay_in_cash', vData.VEHICLE_PRICE),
                method = 'cash'
            }, 
            {
                label = locale('bank'), 
                description = locale('pay_in_bank', vData.VEHICLE_PRICE),
                method = 'bank'
            }
        },
    }
    
    lib.registerMenu({
        id = 'openVehicleSubmenu',
        title = vData.label,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
            if not options[selected].menuArg then return end 
        end,
        onClose = function(keyPressed)
            menu_caching.showMenu(_shopIndex)
            if lib.isTextUIOpen() then lib.hideTextUI() end
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if not selected then return end
        if options[selected].menuArg == 'payment' then
            local alert = lib.alertDialog({
                header = Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_scrollIndex].label,
                content = locale('confirm_purchase',Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_scrollIndex].label, utils.groupDigs(Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_scrollIndex].VEHICLE_PRICE)),
                centered = true,
                cancel = true,
                labels = {confirm = locale('confirm'), cancel = locale('cancel')}
            })
            
            if alert ~= 'confirm' then
                menu_caching.showMenu(_shopIndex)
                return
            end

            proceedPayment(options[selected].values[scrollIndex].method == 'bank', _shopIndex, _selected, _scrollIndex)
            return
        end

        if options[selected].menuArg == 'primary' or options[selected].menuArg == 'secondary' then
            lib.hideMenu(false)
            Wait(100)
            local input = lib.inputDialog(locale('colorize_vehicle'), {
                {type = 'color', default = '#eb4034'},
            })
            if input then
                local r, g, b = utils.hex2rgb(input[1])
                if options[selected].menuArg == 'primary' then
                    SetVehicleCustomPrimaryColour(vehiclePreview, r or 255, g or 0, b or 0)
                else
                    SetVehicleCustomSecondaryColour(vehiclePreview, r or 255, g or 0, b or 0)
                end
            end
            openVehicleSubmenu(subMenu[1], subMenu[2], subMenu[3])
            return
        end
    end)
    lib.showMenu('openVehicleSubmenu')
end

local function openMenu(_shopIndex)
    utils.setLastCoords()

    local CFG_VEHICLE_CLASS = Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST]
    local options = menuOptions.generateMenuOptions(CFG_VEHICLE_CLASS)

    lib.registerMenu({
        id = 'vehicleshop',
        title = Config.vehicleShops[_shopIndex].SHOP_LABEL,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
            menu_caching.scrollCache(CFG_VEHICLE_CLASS[selected], scrollIndex)
            _spawnLocalVehicle(_shopIndex, selected, scrollIndex)
        end,
        onSelected = function(selected, scrollIndex, args)
            menu_caching.selectCache(Config.vehicleShops[_shopIndex], selected)
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
            IS_PLAYER_IN_SHOP = false
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if not selected or not scrollIndex then return end
        while not cache.vehicle and vehiclePreview do
            SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
            Wait(10)
        end

        local vehInfo = menuOptions.getVehicleInfo(vehiclePreview, CFG_VEHICLE_CLASS[selected].values[scrollIndex])
        if vehInfo then
            lib.showTextUI(vehInfo.text, vehInfo.options)
        end

        openVehicleSubmenu(_shopIndex, selected, scrollIndex)
    end)

    utils.fadeOut(500)

    IS_PLAYER_IN_SHOP = true
    SetEntityVisible(cache.ped, false)
    SetEntityCoords(cache.ped, Config.vehicleShops[_shopIndex].PREVIEW_COORDS)
    Wait(500)
    utils.fadeIn(1000)

    menu_caching.showMenu(_shopIndex)
    while not cache.vehicle do
        Wait(100)
    end
    
    notification(Config.vehicleShops[_shopIndex]?.SHOP_LABEL or '[_ERROR_]', locale('tip'), 'tip')
end

local function onEnter(point)
    lib.showTextUI(locale('open_shop', point.shop.label or '_ERROR'), {icon = point.shop.icon or 'car', position = "top-center"})
end

local function onExit(point)
    lib.hideTextUI()
end

local function nearby(point)
    if point.currentDistance <= 2 then
        if IsControlJustPressed(0, 38) and IS_PLAYER_IN_SHOP == false then
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

                if not shopData.SHOWCASE_VEHICLES then
                    goto skip_showcase
                end

                for i=1, #shopData.SHOWCASE_VEHICLES do
                    local showcase_vehicle = shopData.SHOWCASE_VEHICLES[i]
                    if not IsModelInCdimage(showcase_vehicle.SHOWCASE_VEHICLE_MODEL) then return end
                    local modelLoaded = lib.requestModel(showcase_vehicle.SHOWCASE_VEHICLE_MODEL, 1000)
                    if not modelLoaded then return end
                    showcase_vehicle.handle = create_showcase_vehicle(showcase_vehicle, i)
                end

                :: skip_showcase ::

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

    lib.closeAlertDialog()
    lib.hideTextUI()
    
    if IS_PLAYER_IN_SHOP then
        utils.teleportPlayerToLastPos()
    end

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

        if shopData.SHOWCASE_VEHICLES then
            for i=1, #shopData.SHOWCASE_VEHICLES do
                if shopData.SHOWCASE_VEHICLES[i].handle then
                    CreateThread(function()
                        while DoesEntityExist(shopData.SHOWCASE_VEHICLES[i].handle) do
                            SetEntityAsMissionEntity(shopData.SHOWCASE_VEHICLES[i].handle)
                            DeleteEntity(shopData.SHOWCASE_VEHICLES[i].handle)
                            Wait(100)
                        end
                    end)
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