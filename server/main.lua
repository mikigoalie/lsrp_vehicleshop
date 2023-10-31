local _inv = exports.ox_inventory
local plate = require 'modules.generatePlate'
-- Do not rename resource or touch this part of code!
local function initializedThread()
    if GetCurrentResourceName() ~= 'lsrp_vehicleshop' then
        print('^1It is required! to keep the resource name original. Please rename the resource back.^0')
        StopResource(GetCurrentResourceName())
        return
    end

    print('$$\\      $$$$$$\\ $$$$$$$\\ $$$$$$$\\ ')
    print('$$ |    $$  __$$\\$$  __$$\\$$  __$$\\ ')
    print('$$ |    $$ /  \\__$$ |  $$ $$ |  $$ |')
    print('$$ |    \\$$$$$$\\ $$$$$$$  $$$$$$$  |')
    print('$$ |     \\____$$\\$$  __$$<$$  ____/ ')
    print('$$ |    $$\\   $$ $$ |  $$ $$ |      ')
    print('$$$$$$$$\\$$$$$$  $$ |  $$ $$ |      ')
    print('\\________\\______/\\__|  \\__\\__|')
    print('^2LSRP Vehicleshop initialized^0')
end

lib.callback.register('lsrp_vehicleshop:spawnPreview', function(source, _shopIndex, _selected, _scrollIndex)
    local vehicleModel = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].vehicleModel
    local spawnCoords = Config.vehicleShops[_shopIndex].previewCoords
    local promise = spawnVehicle(source, vehicleModel, spawnCoords)
    return promise
end)

lib.callback.register('lsrp_vehicleShop:server:payment', function(source, useBank, _shopIndex, _selected, _secondary)
    if not _shopIndex or not _selected or not _secondary then
        return false
    end


    local vehicleData = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
    local vehiclePrice =vehicleData.vehiclePrice

    if not tonumber(vehiclePrice) or vehiclePrice < 1000 then return false end

    if Config.vehicleShops[_shopIndex].license then
        local hasLicense = MySQL.single.await('SELECT `type` FROM `user_licenses` WHERE `owner` = ? AND `type` = ?', {ESX.GetPlayerFromId(source).identifier, Config.vehicleShops[_shopIndex].license})
        if not hasLicense then
            return 'license'
        end
    end


    if not useBank then
        return _inv:RemoveItem(source, 'money', vehiclePrice)   -- This export should be safe to use this way
    end

    local bankMoney = getBankMoney(source)
    if bankMoney < vehiclePrice then
        return false
    end

    return payBank(source, vehicleData)
end)



lib.callback.register('lsrp_vehicleShop:server:generateplate', function(source)
    return plate.getPlate()
end)



lib.callback.register('lsrp_vehicleShop:server:addVehicle', function(source, vehProperties, vehicleSpot, _shopIndex, _selected, _secondary, useBank)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local data = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
    local coords = xPlayer.getCoords(true)
    local _vehProps = vehProperties

    if _vehProps.model ~= data.vehicleModel then
        return false
    end

    local alreadyExists = MySQL.single.await('SELECT `owner` FROM `owned_vehicles` WHERE `plate` = ?', {vehProperties.plate})

    if alreadyExists?.owner then
        _vehProps.plate = plate.getPlate()
    end

    local success = MySQL.insert.await('INSERT INTO owned_vehicles (`owner`, `plate`, `vehicle`, `stored`, `type`, `name`) VALUES (?, ?, ?, ?, ?, ?)', {xPlayer.identifier, _vehProps.plate, json.encode(_vehProps), vehicleSpot ~= 0, Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].dbData, data.label})
    if vehicleSpot == 0 then
        ESX.OneSync.SpawnVehicle(data.vehicleModel, Config.vehicleShops[_shopIndex].vehicleSpawnCoords.xyz, Config.vehicleShops[_shopIndex].vehicleSpawnCoords.w, _vehProps, function(NetworkId)
            Wait(100)
            local Vehicle = NetworkGetEntityFromNetworkId(NetworkId)
            if DoesEntityExist(Vehicle) then
                SetVehicleDoorsLocked(Vehicle, 1)
                local _vehicleState = Entity(Vehicle).state
                _vehicleState:set('owner', xPlayer.identifier:sub(1, 10), true)
            end
        end)
    end

    log({['Vehicle model'] = data.label, ['Price'] = data.vehiclePrice, ['Plate'] = _vehProps.plate, ['Buyer'] = GetPlayerName(source), ['Player identifier'] = xPlayer.identifier, ['Payment type'] = useBank and locale('bank') or locale('cash')})
    
    return success, _vehProps.plate, vehicleSpot ~= 0, Vehicle
    
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
end)

MySQL.ready(initializedThread)
