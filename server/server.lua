local db = require('server.modules.database')
local plate = require('server.modules.plate')
local functions = require('server.modules.functions')
local framework = require('server.bridge.framework')
local dprint = require('shared.modules.dprint')

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
end MySQL.ready(initializedThread)

lib.callback.register('lsrp_vehicleShop:server:payment', function(source, useBank, _shopIndex, _selected, _secondary)
    if not _shopIndex or not _selected or not _secondary then
        return false
    end


    local vehicleData = Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_secondary]
    local VEHICLE_PRICE =vehicleData.VEHICLE_PRICE

    if not tonumber(VEHICLE_PRICE) or VEHICLE_PRICE < 1000 then return false end

    if Config.vehicleShops[_shopIndex].license then
        local gotLicense = framework.checkLicense(source, Config.vehicleShops[_shopIndex].license)
        if not gotLicense then
            return 'license'
        end
    end


    if not useBank then
        return framework.paymentCASH(source, VEHICLE_PRICE)
    end

    local bankMoney = framework.getBankBalance(source)
    if bankMoney < VEHICLE_PRICE then
        return false
    end

    return framework.paymentBANK(source, vehicleData)
end)






lib.callback.register('lsrp_vehicleShop:server:addVehicle', function(source, vehProperties, vehicleSpot, _shopIndex, _selected, _secondary, useBank)
    local player = framework.getPlayer(source)
    if not player then return false end

    local _vehProps = vehProperties
    local data = Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].values[_secondary]

    if _vehProps.model ~= data.VEHICLE_MODEL then
        return false
    end

    if plate.plateTaken(_vehProps.plate) then
        _vehProps.plate = plate.getPlate()
    end

    local playerIdentifier = framework.getPlayerIdentifier(source)
    if not playerIdentifier then return false end

    local success = MySQL.insert.await('INSERT INTO owned_vehicles (`owner`, `plate`, `vehicle`, `stored`, `type`, `name`) VALUES (?, ?, ?, ?, ?, ?)', {playerIdentifier, _vehProps.plate, json.encode(_vehProps), vehicleSpot ~= 0, Config.VEHICLE_LIST[Config.vehicleShops[_shopIndex].VEHICLE_LIST][_selected].dbData, data.label})
    if vehicleSpot == 0 then
        ESX.OneSync.SpawnVehicle(data.VEHICLE_MODEL, Config.vehicleShops[_shopIndex].PURCHASED_VEHICLE_SPAWNS.xyz, Config.vehicleShops[_shopIndex].PURCHASED_VEHICLE_SPAWNS.w, _vehProps, function(NetworkId)
            Wait(100)
            local Vehicle = NetworkGetEntityFromNetworkId(NetworkId)
            if DoesEntityExist(Vehicle) then
                SetVehicleDoorsLocked(Vehicle, 1)
                local _vehicleState = Entity(Vehicle).state
                _vehicleState:set('owner', playerIdentifier:sub(1, 10), true)
            end
        end)
    end

    functions.log({['Vehicle model'] = data.label, ['Price'] = data.VEHICLE_PRICE, ['Plate'] = _vehProps.plate, ['Buyer'] = GetPlayerName(source), ['Player identifier'] = playerIdentifier, ['Payment type'] = useBank and locale('bank') or locale('cash')})
    
    return success, _vehProps.plate, vehicleSpot ~= 0, Vehicle
    
end)


RegisterNetEvent('lsrp_vehicleshop:actions', function(data)
    local player, playerName = source, GetPlayerName(source)
    if not next(data) then dprint(('Player %s (%s) has executed an event without parameters. Possible cheating'):format(playerName, player)) return end


    dprint(('Player %s (%s) has entered a shop'):format(playerName, player))
end)