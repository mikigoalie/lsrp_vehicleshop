local db = require('server.modules.database')
local plate = require('server.modules.plate')
local functions = require('server.modules.functions')

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


    local vehicleData = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
    local vehiclePrice =vehicleData.vehiclePrice

    if not tonumber(vehiclePrice) or vehiclePrice < 1000 then return false end

    if Config.vehicleShops[_shopIndex].license then
        local gotLicense = functions.checkLicense(source, Config.vehicleShops[_shopIndex].license)
        if not gotLicense then
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

    local _vehProps = vehProperties
    local data = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]

    if _vehProps.model ~= data.vehicleModel then
        return false
    end

    if plate.plateTaken(_vehProps.plate) then
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

    functions.log({['Vehicle model'] = data.label, ['Price'] = data.vehiclePrice, ['Plate'] = _vehProps.plate, ['Buyer'] = GetPlayerName(source), ['Player identifier'] = xPlayer.identifier, ['Payment type'] = useBank and locale('bank') or locale('cash')})
    
    return success, _vehProps.plate, vehicleSpot ~= 0, Vehicle
    
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
end)


function getBankMoney(source)
    return exports.pefcl:getDefaultAccountBalance(source).data
end

function payBank(source, vehicleData)
    local result = exports.pefcl:removeBankBalance(source, { amount = vehicleData.vehiclePrice, message = ('Zakoupení vozidla %s'):format(vehicleData.label) })
    return result.status == 'ok' or false
end