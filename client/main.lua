lib.locale()
local blips = {}

local vehiclePreview = nil
local playerLoaded = false
local _playerInShop = false
local shopPoint = {}
local lastCoords = nil
local lastIndex = nil
local loadingVehicle = false
local _inv = exports.ox_inventory

local function groupDigs(price)
	local left,num,right = string.match(price,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ','):reverse())..right
end

local function notification(title, msg, _type)
    lib.notify({
        title = title or '[_ERROR_]',
        duration = Config.notifDuration,
        description = msg,
        position = Config.menuPosition == 'right' and 'top-left' or 'top-right', 
        type = _type or inform
    })
end

local function _deleteVehicle()
    if vehiclePreview then
        SetVehicleAsNoLongerNeeded(vehiclePreview)
        SetEntityAsMissionEntity(vehiclePreview)
        DeleteVehicle(vehiclePreview)
    end
	vehiclePreview = nil
end

local function _spawnLocalVehicle(_shopIndex, _selected, _scrollIndex)
    _deleteVehicle()

    if loadingVehicle or vehiclePreview then return end

    local _data = Config.vehicleShops[_shopIndex]
    local _model = Config.vehicleList[_data.vehicleList][_selected].values[_scrollIndex].vehicleModel
    if not IsModelInCdimage(_model) then return end
    RequestModel(_model) -- Request the model
    while not HasModelLoaded(_model) do -- Waits for the model to load
        loadingVehicle = true
      Wait(0)
    end
    loadingVehicle = false
    vehiclePreview = CreateVehicle(_model, _data.previewCoords.x, _data.previewCoords.y, _data.previewCoords.z, _data.previewCoords.w, false,false)
    SetPedIntoVehicle(cache.ped, vehiclePreview, -1)
    if GetVehicleDoorLockStatus(vehiclePreview) ~= 4 then
        SetVehicleDoorsLocked(vehiclePreview, 4)
    end

    SetVehicleEngineOn(vehiclePreview, false, false, true)
    SetVehicleHandbrake(vehiclePreview, true)
    SetVehicleInteriorlight(vehiclePreview, true) -- from KQ, but not sure it work
    FreezeEntityPosition(vehiclePreview, true)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end

    for _, shopData in pairs(Config.vehicleShops) do
        if DoesBlipExist(shopData.blipData.blip) then
            RemoveBlip(shopData.blipData.blip)
        end
    end

    if vehiclePreview then
        SetEntityAsMissionEntity(vehiclePreview)
        _deleteVehicle(vehiclePreview)
        ResetEntityAlpha(cache.ped)
		vehiclePreview = nil
    end
end)

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

	if success then
		local vehicleAdded, vehiclePlate, spotTaken = lib.callback.await('lsrp_vehicleShop:server:addVehicle', 2000, ESX.Game.GetVehicleProperties(vehiclePreview), #lib.getNearbyVehicles(Config.vehicleShops[_shopIndex].vehicleSpawnCoords.xyz, 3, true), _shopIndex, _selected, _secondary)
		if vehicleAdded then
            local data = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
			DoScreenFadeOut(500)
			while not IsScreenFadedOut() do
				Wait(10)
			end
            if vehiclePreview then
                _deleteVehicle(vehiclePreview)
            end
			PlaySoundFrontend(-1, 'Pre_Screen_Stinger', 'DLC_HEISTS_FAILED_SCREEN_SOUNDS', 0)
            notification(Config.vehicleShops[_shopIndex]?.shopLabel, locale('success_bought', Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].label, vehiclePlate), 'success')
			ResetEntityAlpha(cache.ped)
			Wait(1000)
            SetEntityCoords(cache.ped, lastCoords.xyz)
            SetEntityVisible(cache.ped, true)
			DoScreenFadeIn(1000)
            notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', not spotTaken and locale('vehicle_pick_up', data.label, vehiclePlate) or locale('added_to_garage', data.label, vehiclePlate), 'success')
			return
		end

        notification(Config.vehicleShops[_shopIndex]?.shopLabel or '[_ERROR_]', locale('error_while_saving'), 'error')
	end
end

local function getVehicleData(_shopIndex, selected, secondary)
    local r, g, b = GetVehicleColor(vehiclePreview)
    local data = {
        plate = GetVehicleNumberPlateText(vehiclePreview),
        vehicleSeats = GetVehicleModelNumberOfSeats(Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][selected].values[secondary].vehicleModel),
        color = {r = r, g = g, b = b},
        maxBraking = GetVehicleModelMaxBrakingMaxMods(Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][selected].values[secondary].vehicleModel),
        topSpeed = GetVehicleEstimatedMaxSpeed(vehiclePreview)
    }
    return data.plate and data or false
end

local function openVehicleSubmenu(_shopIndex, _selected, _scrollIndex)
    local options = {}

    Config.vehicleColors.data[1].colorRGB.r, Config.vehicleColors.data[1].colorRGB.g, Config.vehicleColors.data[1].colorRGB.b = GetVehicleColor(vehiclePreview)


    if Config.vehicleColors.primary == true then
        options[#options+1] = {icon = 'droplet', label = locale('primary_color'), values = Config.vehicleColors.data, menuArg = 'primary'}
    end
    
    if Config.vehicleColors.secondary == true then
        options[#options+1] = {icon = 'droplet', label = locale('secondary_color'), values = Config.vehicleColors.data, menuArg = 'secondary'}
    end

    options[#options+1] = {
        label = 'Platba',
        icon = 'credit-card',
        menuArg = 'payment',
        values = {
            {
                label = locale('cash'), 
                description = locale('pay_in_cash', Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].vehiclePrice),
                method = 'cash'
            }, 
            {
                label = locale('bank'), 
                description = locale('pay_in_bank', Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].vehiclePrice),
                method = 'bank'
            }
        },
    }
    
    lib.registerMenu({
        id = 'openVehicleSubmenu',
        title = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].label,
        position = Config.menuPosition == 'right' and 'top-right' or 'top-left',
        
        onSideScroll = function(selected, scrollIndex, args)
            if not options[selected].menuArg then 
                return 
            end

            

            if options[selected].menuArg == 'primary' then
                local colorData = options[selected].values[scrollIndex].colorRGB
                SetVehicleCustomPrimaryColour(vehiclePreview, colorData[1], colorData[2], colorData[3])
                return
            end

            if options[selected].menuArg == 'secondary' then
                local colorData = options[selected].values[scrollIndex].colorRGB
                SetVehicleCustomSecondaryColour(vehiclePreview, colorData[1], colorData[2], colorData[3])
                return
            end
        end,
        onSelected = function(selected, scrollIndex, args)


            if not options[selected].menuArg then 
                return 
            end

            

            if options[selected].menuArg == 'primary' then
                local colorData = options[selected].values[scrollIndex].colorRGB
                SetVehicleCustomPrimaryColour(vehiclePreview, colorData[1], colorData[2], colorData[3])
                return
            end

            if options[selected].menuArg == 'secondary' then
                local colorData = options[selected].values[scrollIndex].colorRGB
                SetVehicleCustomSecondaryColour(vehiclePreview, colorData[1], colorData[2], colorData[3])
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
                content = locale('confirm_purchase',Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].label, groupDigs(Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].vehiclePrice)),
                centered = true,
                cancel = true,
                labels = {confirm = locale('confirm'), cancel = locale('cancel')}
            })
            
            if alert ~= 'confirm' then
                lib.showMenu('vehicleshop')
                return
            end

            proceedPayment(options[selected].values[scrollIndex].method == 'bank', _shopIndex, _selected, _scrollIndex)
        end
    end)
    lib.showMenu('openVehicleSubmenu')
end
lib.closeAlertDialog()
local function openMenu(_shopIndex)
    local hintShown = false
    lastCoords = GetEntityCoords(cache.ped)

    local options = {}
    local _vehicleClassCFG = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList]


    for classIndex, classInfo in pairs(_vehicleClassCFG) do
        for i=1, #classInfo.values do
            classInfo.values[i].description = locale('priceTag', groupDigs(classInfo.values[i].vehiclePrice))
        end
        
        options[#options+1] = {
            label = locale(classInfo.label),
            description = classInfo.description,
            icon = classInfo.icon or 'car',
            arrow = true,
            values = classInfo.values,
            classIndex = classIndex
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
            DoScreenFadeOut(duration or 500)
            while not IsScreenFadedOut() do
                Wait(50)
            end
            while DoesEntityExist(vehiclePreview) do
                _deleteVehicle()
            end
            --local selfInstance = lib.callback.await('lsrp_vehicleshop:setInstance', 5000, false)
            SetEntityCoords(cache.ped, lastCoords)
            Wait(duration or 1000)
            SetEntityVisible(cache.ped, true)
            DoScreenFadeIn(duration or 1000)
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

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(50)
    end

    SetEntityVisible(cache.ped, false)
    SetEntityCoords(cache.ped, Config.vehicleShops[_shopIndex].previewCoords)
    --local selfInstance = lib.callback.await('lsrp_vehicleshop:setInstance', 5000, true)
    Wait(500)
    DoScreenFadeIn(duration or 1000)
    lib.showMenu('vehicleshop')
end

local function onEnter(point)
    lib.showTextUI(locale('open_shop', point.shopLabel or '_ERROR'), {icon = 'car', position = "top-center"})
end

local function onExit(point)
    lib.hideTextUI()
end

local function nearby(point)
    if point.currentDistance <= 2 then
        if IsControlJustPressed(0, 38) and _playerInShop == false then
            lib.hideTextUI()
            openMenu(point.shopIndex)
        end
    end
end

local function createPoint(data)
	return lib.points.new(data.shopCoords, Config.textDistance, {nearby = nearby, onEnter = onEnter, onExit = onExit, shopLabel = data.shopLabel, shopIndex = data.index})
end

local function createNpc(model, coords)
    lib.requestModel(model)
    local npcHandle = CreatePed(5, model, coords.x, coords.y, coords.z, coords.w, false, true)
    FreezeEntityPosition(npcHandle, true)
    SetEntityInvincible(npcHandle, true)
    SetBlockingOfNonTemporaryEvents(npcHandle, true)
    SetPedCanBeTargetted(npcHandle, false)
    SetEntityAsMissionEntity(npcHandle, true, true)
    TaskStartScenarioInPlace(npcHandle, 'WORLD_HUMAN_GUARD_STAND')
    return npcHandle
end

local function mainThread()
    for _, shopData in pairs(Config.vehicleShops) do
        shopData.blipData.blip = AddBlipForCoord(shopData.shopCoords.xyz)
        local blip = shopData.blipData.blip 
        SetBlipSprite(blip, shopData.blipData.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, shopData.blipData.scale)
        SetBlipColour(blip, shopData.blipData.color)
        SetBlipSecondaryColour(blip, 255, 0, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shopData.shopLabel)
        EndTextCommandSetBlipName(blip)
    end

	while ESX.IsPlayerLoaded() do
		local playerCoords = GetEntityCoords(cache.ped)
        for idx, shopData in pairs(Config.vehicleShops) do
            local currentDistance = #(playerCoords - shopData.shopCoords)
            if currentDistance > 100 then
                if shopData.point then
                    shopData.point:remove()
                    DeletePed(shopData.npcData.npc)
                end

                goto continue
            end

            if shopData.point then
                goto continue
            end

            shopData.point = createPoint({shopCoords = shopData.shopCoords, index = idx, shopLabel = shopData.shopLabel})
            shopData.npcData.npc = createNpc(shopData.npcData.model, shopData.npcData.position)
            :: continue ::
        end
		Wait(1000)
	end
end 

if ESX.IsPlayerLoaded() then
    CreateThread(mainThread)
    playerLoaded = true
end

AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    if playerLoaded then
        return
    end
    playerLoaded = true
    CreateThread(mainThread)
end)

AddEventHandler('esx:onPlayerLogout', function()
    for i=1, #shopPoint do
        if shopPoint[i] then
            shopPoint[i]:remove()
        end
    end
    playerLoaded = false
end)

