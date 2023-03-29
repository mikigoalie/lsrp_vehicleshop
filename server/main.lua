local _inv = exports.ox_inventory
local _pefcl = exports.pefcl

lib.callback.register('lsrp_vehicleshop:setInstance', function(source, entered)
    SetPlayerRoutingBucket(source, entered and source or 0)
    return GetPlayerRoutingBucket(source) == source
end)

lib.callback.register('lsrp_vehicleshop:spawnPreview', function(source, _shopIndex, _selected, _scrollIndex)
    local vehicleModel = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_scrollIndex].vehicleModel
    local spawnCoords = Config.vehicleShops[_shopIndex].previewCoords
    local promise = spawnVehicle(source, vehicleModel, spawnCoords)
    return promise
end)

lib.callback.register('lsrp_vehicleShop:server:payment', function(source, useBank, _shopIndex, _selected, _secondary)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    if not _shopIndex or not _selected or not _secondary then
        return false
    end

    local vehiclePrice = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].vehiclePrice
    print(vehiclePrice)
    if not tonumber(vehiclePrice) or vehiclePrice < 1000 then return false end

    if not useBank then
        local money = _inv:GetItem(source, 'money', nil, true)
        if money < vehiclePrice then
            return false
        end

        return _inv:RemoveItem(source, 'money', vehiclePrice)
    end

    local bankMoney = _pefcl:getDefaultAccountBalance(source).data
    print(bankMoney)
    if bankMoney < vehiclePrice then
        return false
    end

    local result = _pefcl:removeBankBalance(source, { amount = vehiclePrice, message = ('Zakoupení vozidla %s'):format(Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary].label) })
    return result.status == 'ok' or false
end)

local function getPlate()
    local str = nil
    repeat
        str = ESX.GetRandomString(8)
        local alreadyExists = MySQL.single.await('SELECT owner FROM owned_vehicles WHERE plate = ?', {str})
    until not alreadyExists?.owner
    return str
end


lib.callback.register('lsrp_vehicleShop:server:addVehicle', function(source, vehProperties, vehicleSpot, _shopIndex, _selected, _secondary)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local data = Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].values[_secondary]
    local coords = xPlayer.getCoords(true)
    local _vehProps = vehProperties

    print(('VEH MODELS %s %s'):format(_vehProps.model, data.vehicleModel))
    if _vehProps.model ~= data.vehicleModel then
        return false
    end

    local alreadyExists = MySQL.single.await('SELECT owner FROM owned_vehicles WHERE plate = ?', {vehProperties.plate})
    print(('DB EXIST? %s'):format(alreadyExists))

    if alreadyExists?.owner then
        _vehProps.plate = getPlate()
    end

    local success = MySQL.insert.await('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type) VALUES (?, ?, ?, ?, ?)', {xPlayer.identifier, _vehProps.plate, json.encode(_vehProps), vehicleSpot ~= 0, Config.vehicleList[Config.vehicleShops[_shopIndex].vehicleList][_selected].dbData})
    print(('DSUICCCESS? %s'):format(success))
    if vehicleSpot == 0 then
        ESX.OneSync.SpawnVehicle(data.vehicleModel, Config.vehicleShops[_shopIndex].vehicleSpawnCoords.xyz, Config.vehicleShops[_shopIndex].vehicleSpawnCoords.w, _vehProps, function(NetworkId)
            Wait(100)
            local Vehicle = NetworkGetEntityFromNetworkId(NetworkId)
            if DoesEntityExist(Vehicle) then
                SetVehicleDoorsLocked(Vehicle, 1)
            end
        end)
    end

    print(('SUC %s, PLATE %s, VEHSPOT %s'):format(success, _vehProps.plate, vehicleSpot ~= 0))
    
    return success, _vehProps.plate, vehicleSpot ~= 0
end)


RegisterCommand("dbtest", function(source, args, rawCommand)
    local success = MySQL.insert.await('INSERT INTO carthief (identifier, timeleft) VALUES (?, ?)', {'NEGER', 50})
    print(success)
end)




AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
end)