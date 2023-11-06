local db = require('server.modules.database')
local plate = require('server.modules.plate')
local functions = require('server.modules.functions')
local framework = require('server.bridge.framework')
local dprint = require('shared.modules.dprint')
local spawnVehicle = require('server.modules.spawnVehicle')
local hooks = require('server.bridge.hooks')

local function initializedThread()
    if GetCurrentResourceName() ~= 'lsrp_vehicleshop' then
        print('^1It is required! to keep the resource name original. Please rename the resource back.^0')
        StopResource(GetCurrentResourceName())
        return
    end


    result = MySQL.query.await(('SHOW COLUMNS FROM `%s`'):format(Config.vehicleTable, {indent=true}))
    local nameField = false

    for i = 1, #result do
        if result[i].Field == 'name' then
            nameField = true
        end
    end

    if not nameField then
        dprint(('Inserting `nameField` in `%s`'):format(Config.vehicleTable))
        MySQL.query(('ALTER TABLE `%s` ADD COLUMN `name` VARCHAR(40) DEFAULT `Unknown`'):format(Config.vehicleTable))
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

local function addVehicleToPlayer(source, vehicle, shopIndex, selectIndex, paymentMethod)

    local clientData = lib.callback.await('lsrp_vehicleshop:server:proceed', source, shopIndex)
    if not clientData.vehicleProperties or clientData.vehicleProperties.model ~= vehicle.VEHICLE_MODEL then return false end

    if plate.plateTaken(clientData.vehicleProperties.plate) then
        clientData.vehicleProperties.plate = plate.getPlate()
    end

    local playerIdentifier = framework.getPlayerIdentifier(source)
    if not playerIdentifier then return false end

    local success = db.addVehicle({
        identifier = playerIdentifier,
        plate = clientData.vehicleProperties.plate,
        properties = json.encode(clientData.vehicleProperties),
        hasFreeCoords = clientData.vehicleSpawnCoords and true,
        vehicleType = Config.VEHICLE_LIST[Config.vehicleShops[shopIndex].VEHICLE_LIST][selectIndex].dbData,
        vehicleName = vehicle.label
    })

    if not success then return false end

    if type(clientData.vehicleSpawnCoords) == "vector3" or type(clientData.vehicleSpawnCoords) == "vector4" then
        spawnVehicle(vehicle.VEHICLE_MODEL, clientData.vehicleSpawnCoords, clientData.vehicleProperties, playerIdentifier)
    end

    hooks.onVehiclePurchase(vehicle.label, clientData.vehicleProperties.plate)
    dprint(('Purchase made! Player %s has purchased %s for %s'):format(source, vehicle.VEHICLE_MODEL, vehicle.VEHICLE_PRICE))
    functions.log({['Vehicle model'] = vehicle.label, ['Price'] = vehicle.VEHICLE_PRICE, ['Plate'] = clientData.vehicleProperties.plate, ['Buyer'] = GetPlayerName(source), ['Player identifier'] = playerIdentifier, ['Payment type'] = paymentMethod, ['Spawned around shop'] = clientData.vehicleSpawnCoords and true})
    
    return true, clientData.vehicleSpawnCoords and true, clientData.vehicleProperties.plate
end

lib.callback.register('lsrp_vehicleShop:server:payment', function(source, paymentMethod, shopIndex, selectIndex, scrollIndex)
    if not shopIndex or not selectIndex or not scrollIndex then
        dprint(('Player with ID: %s has called a callback without args. Possible cheating'):format(source))
        return false
    end

    local vehicleData = Config.VEHICLE_LIST[Config.vehicleShops[shopIndex].VEHICLE_LIST][selectIndex].values[scrollIndex]
    local VEHICLE_PRICE = vehicleData.VEHICLE_PRICE

    if type(VEHICLE_PRICE) ~= 'number' or VEHICLE_PRICE < 1000 then
        dprint(('An error has occured while getting vehicle price for vehicle %s'):format(vehicleData?.VEHICLE_MODEL))
        return false 
    end

    if Config.vehicleShops[shopIndex].license then
        if not framework.checkLicense(source, Config.vehicleShops[shopIndex].license) then
            return false
        end
    end

    if not framework.payment(source, paymentMethod, VEHICLE_PRICE) then
        return false
    end


    return addVehicleToPlayer(source, vehicleData, shopIndex, selectIndex, paymentMethod)
end)


RegisterNetEvent('lsrp_vehicleshop:actions', function(data)
    local player, playerName = source, GetPlayerName(source)
    if not next(data) then dprint(('Player %s (%s) has executed an event without parameters. Possible cheating'):format(playerName, player)) return end


    dprint(('Player %s (%s) has entered a shop'):format(playerName, player))
end)