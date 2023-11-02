local npc = require('client.modules.npc')
local blipModule = require('client.modules.blip')
local utils = require('client.modules.utils')
local notification = require('client.modules.notify')
local create_showcase_vehicle = require('client.modules.showcase')

local vehiclePreview = nil
local playerLoaded = false
local IS_PLAYER_IN_SHOP = false
local shopPoint = {}
local lastIndex = nil
local loadingVehicle = false
local vehicleInvData = {}

local function loadInventoryData()
    vehicleInvData.inventoryStarted = GetResourceState('ox_inventory'):find('start') ~= nil
    if not vehicleInvData.inventoryStarted then return end

    local file = "data/vehicles.lua"
    local import = LoadResourceFile("ox_inventory", file)
    local chunk = assert(load(import, ('@@ox_inventory/%s'):format(file)))

    if not chunk then
        vehicleInvData.inventoryStarted = false
        return
    end

    local vehData = chunk()

    vehicleInvData.trunk = vehData.trunk
    vehicleInvData.glovebox = vehData.glovebox
end

local function _spawnLocalVehicle(_shopIndex, _selected, _scrollIndex)
    vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
    if loadingVehicle or vehiclePreview then return end
    local _data = Config.vehicleShops[_shopIndex]
    local _model = Config.vehicleList[_data.vehicleList][_selected].values[_scrollIndex].vehicleModel
    loadingVehicle = true
    if not utils.loadModel(_model) then 
        loadingVehicle = false
        return 
    end
    vehiclePreview = CreateVehicle(_model, _data.previewCoords.x, _data.previewCoords.y, _data.previewCoords.z, _data.previewCoords.w, false,false)
    utils.setVehicleProperties(vehiclePreview)
    SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
    loadingVehicle = false
end



local function proceedPayment(useBank, _shopIndex, _selected, _secondary)
    if not useBank then
        local count = _inv:Search('count', 'money')
        if count < Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].vehiclePrice then
            notification(Config.vehicleShops[_shopIndex]?.shopLabel, locale('not_enough_money', Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].vehiclePrice), 'error')
            lib.showMenu('vehicleshop')
            return
        end
    end

	local success = lib.callback.await('lsrp_vehicleShop:server:payment', false, useBank, _shopIndex, _selected, _secondary)
    if not success then
        notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', locale('transaction_error'), 'error')
        lib.showMenu('vehicleshop')
        return
    end

    if success == 'license' then
        notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', locale('license'), 'error')
        lib.showMenu('vehicleshop')
        return
    end

	if success then
		local vehicleAdded, vehiclePlate, spotTaken, netId = lib.callback.await('lsrp_vehicleShop:server:addVehicle', 500, lib.getVehicleProperties(vehiclePreview), #lib.getNearbyVehicles(Config.vehicleShops[_shopIndex].vehicleSpawnCoords.xyz, 3, true), _shopIndex, _selected, _secondary, useBank)
        if vehicleAdded then
            local data = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
            utils.fadeOut(500)
            if vehiclePreview then
                vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
            end
			PlaySoundFrontend(-1, 'Pre_Screen_Stinger', 'DLC_HEISTS_FAILED_SCREEN_SOUNDS', 0)
            notification(Config.vehicleShops[_shopIndex]?.shopLabel, locale('success_bought', Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].label, vehiclePlate), 'success')
			Wait(1000)
            utils.teleportPlayerToLastPos()
            SetEntityVisible(cache.ped, true)
            utils.fadeIn(1000)
            notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', not spotTaken and locale('vehicle_pick_up', data.label, vehiclePlate) or locale('added_to_garage', data.label, vehiclePlate), 'success')
            npc.deleteFromVeh(NetToVeh(netId))
            return
		end

        notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', locale('error_while_saving'), 'error')
	end
end

local function openVehicleSubmenu(_shopIndex, _selected, _scrollIndex)
    local subMenu = {_shopIndex, _selected, _scrollIndex}
    local vData = Config.vehicleList[Config.vehicleShops[subMenu[1]].vehicleList][subMenu[2]].values[subMenu[3]]
    local vClass = GetVehicleClass(vehiclePreview)
    local options = {
        {close = false, icon = 'info', label = locale('vehicle_info'), 
        values = {
            {
                label = locale('trunk'),
                description = vehicleInvData.trunk[vClass] and ('%s %s - %s kg'):format(vehicleInvData.trunk[vClass][1], locale('slots'), utils.groupDigs(vehicleInvData.trunk[vClass][2], '.')) or locale('notrunk'),
            },
            {
                label = locale('glovebox'),
                description = vehicleInvData.glovebox[vClass] and ('%s %s - %s kg'):format(vehicleInvData.glovebox[vClass][1], locale('slots'), utils.groupDigs(vehicleInvData.glovebox[vClass][2], '.')) or locale('noglove'),
            },
            {
                label = locale('est_speed'),
                description = ('%.2f kmh'):format(GetVehicleModelEstimatedMaxSpeed(vData.vehicleModel) * 3.6),
            },
            {
                label = locale('seats'),
                description = GetVehicleModelNumberOfSeats(vData.vehicleModel),
            },
            {
                label = locale('plate'),
                description = GetVehicleNumberPlateText(vehiclePreview),
            },
        }}  
    }

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
                description = locale('pay_in_cash', vData.vehiclePrice),
                method = 'cash'
            }, 
            {
                label = locale('bank'), 
                description = locale('pay_in_bank', vData.vehiclePrice),
                method = 'bank'
            }
        },
    }
    
    lib.registerMenu({
        id = 'openVehicleSubmenu',
        title = vData.label,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
            if not options[selected].menuArg then 
                return 
            end 
        end,
        onClose = function(keyPressed)
            lib.showMenu('vehicleshop')
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if not selected then return end
        if options[selected].menuArg == 'payment' then
            local alert = lib.alertDialog({
                header = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].label,
                content = locale('confirm_purchase',Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].label, utils.groupDigs(Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].vehiclePrice)),
                centered = true,
                cancel = true,
                labels = {confirm = locale('confirm'), cancel = locale('cancel')}
            })
            
            if alert ~= 'confirm' then
                lib.showMenu('vehicleshop')
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
    local hintShown = false
    utils.setLastCoords()

    local options = {}
    local _vehicleClassCFG = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList]

    for classIndex, classInfo in pairs(_vehicleClassCFG) do
        for i=1, #classInfo.values do
            classInfo.values[i].description = locale('priceTag', utils.groupDigs(classInfo.values[i].vehiclePrice))
        end
        
        options[#options+1] = {
            label = locale(classInfo.label),
            description = classInfo.description,
            icon = classInfo.icon or 'car',
            iconColor = classInfo.menuColor or "",
            arrow = true,
            values = classInfo.values,
            classIndex = classIndex,
        }
    end

    lib.registerMenu({
        id = 'vehicleshop',
        title = Config.vehicleShops[_shopIndex].shopLabel,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        onSideScroll = function(selected, scrollIndex, args)
            _spawnLocalVehicle(_shopIndex, selected, scrollIndex)
        end,
        onSelected = function(selected, scrollIndex, args)
            if not hintShown then
                notification('TIP', locale('tip'), 'inform')
                hintShown = true
            end

            _spawnLocalVehicle(_shopIndex, selected, scrollIndex)
        end,
        onClose = function(keyPressed)
            utils.fadeOut(500)
            utils.teleportPlayerToLastPos()
            while DoesEntityExist(vehiclePreview) do
                vehiclePreview = utils.deleteLocalVehicle(vehiclePreview)
            end
            Wait(500)
            SetEntityVisible(cache.ped, true)
            utils.fadeIn(1000)
            Wait(500)

        end,
        options = options
    }, function(selected, scrollIndex, args)
        if not selected or not scrollIndex then return end
        while not cache.vehicle and vehiclePreview do
            SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
            Wait(5)
        end

        openVehicleSubmenu(_shopIndex, selected, scrollIndex)
    end)

    utils.fadeOut(500)

    SetEntityVisible(cache.ped, false)
    SetEntityCoords(cache.ped, Config.vehicleShops[_shopIndex].previewCoords)
    Wait(500)
    utils.fadeIn(1000)
    lib.showMenu('vehicleshop')
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
	return lib.points.new(data.shopCoords, Config.textDistance, {nearby = nearby, onEnter = onEnter, onExit = onExit, shop = data.shopData})
end

local function mainThread()
    loadInventoryData()

    for _, shopData in pairs(Config.vehicleShops) do
        shopData.blipData.blip = blipModule.createBlip(shopData)
    end

    while playerLoaded do
		local playerCoords = GetEntityCoords(cache.ped)

        for idx, shopData in pairs(Config.vehicleShops) do
            if #(playerCoords - shopData.shopCoords) > 200.0 then
                if shopData.point then
                    shopData.point:remove()
                    shopData.point = nil
                end
                if shopData.npcData.npc then
                    DeleteEntity(shopData.npcData.npc)
                    shopData.npcData.npc = nil
                end
                if shopData.showcaseVehicle then
                    for i=1, #shopData.showcaseVehicle do
                        if shopData.showcaseVehicle[i].handle then
                            while DoesEntityExist(shopData.showcaseVehicle[i].handle) do
                                SetEntityAsMissionEntity(shopData.showcaseVehicle[i].handle)
                                DeleteEntity(shopData.showcaseVehicle[i].handle)
                                Wait(100)
                            end
                        end
                    end
                end

                goto continue
            end

            
            if #(playerCoords - shopData.shopCoords) < 150.0 then
                if shopData.point or shopData?.npcData?.npc then
                    goto continue
                end

                if not shopData.showcaseVehicle then
                    goto skip_showcase
                end

                for i=1, #shopData.showcaseVehicle do
                    local showcase_vehicle = shopData.showcaseVehicle[i]
                    if not IsModelInCdimage(showcase_vehicle.vehicleModel) then return end
                    local modelLoaded = lib.requestModel(showcase_vehicle.vehicleModel, 1000)
                    if not modelLoaded then return end
                    showcase_vehicle.handle = create_showcase_vehicle(showcase_vehicle, i)
                end

                :: skip_showcase ::

                shopData.npcData.npc = npc.create(shopData.npcData.model, shopData.npcData.position)

                if Config.oxTarget then
                    exports.ox_target:addLocalEntity(shopData.npcData.npc, {
                        {
                            name = 'vehicleshop',
                            icon = shopData.menuIcon or 'car',
                            label = locale('open_shop', shopData.shopLabel or '_ERROR'),
                            distance = 2.5,
                            onSelect = function(data)
                                openMenu(idx)
                            end
                        }
                    })
                else
                    shopData.point = createPoint({shopCoords = shopData.shopCoords, shopData = { label = shopData.shopLabel, icon = shopData.menuIcon, index = idx}})
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

    for _, shopData in pairs(Config.vehicleShops) do
        blipModule.removeBlip(shopData.blipData.blip)
        
        if shopData.point then
            shopData.point:remove()
            shopData.point = nil
        end

        if shopData.npcData.npc then
            DeletePed(shopData.npcData.npc)
            shopData.npcData.npc = nil
        end

        if shopData.showcaseVehicle then
            for i=1, #shopData.showcaseVehicle do
                if shopData.showcaseVehicle[i].handle then
                    CreateThread(function()
                        while DoesEntityExist(shopData.showcaseVehicle[i].handle) do
                            SetEntityAsMissionEntity(shopData.showcaseVehicle[i].handle)
                            DeleteEntity(shopData.showcaseVehicle[i].handle)
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

AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    if playerLoaded then
        return
    end

    playerLoaded = true
    CreateThread(mainThread)
end)


AddEventHandler('esx:onPlayerLogout', function()
    onShutDown()
end)

local RES_NAME = GetCurrentResourceName()
AddEventHandler('onResourceStop', function(resourceName)
    if (RES_NAME ~= resourceName) then return end

    onShutDown()
end)


lib.onCache('vehicle', function(value)
    if not vehiclePreview then
        return
    end

    if not value then
        return
    end

    Wait(0)

    DisplayRadar(false)
end)