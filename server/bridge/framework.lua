local db = require('server.modules.database')
local framework = {}

local plate = require('server.modules.plate')
lib.callback.register('lsrp_vehicleShop:server:generateplate', function(source)
    return plate.getPlate()
end)


framework.getPlayerIdentifier = function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId) 
    return xPlayer and xPlayer.identifier or false
end

framework.payment = function(source, method, price)
    if Config.payment = "esx" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        local bank = xPlayer.getAccount("bank")?.money
        if not bank or not tonumber(bank) == "number" then return false end
        if bank < price then return false end
        xPlayer.removeAccountMoney('bank', price)
        return true
    elseif Config.payment == "pefcl" then
        if method and method == "bank" then
            if not exports.pefcl:getDefaultAccountBalance(source).data > price then return false end
            local result = exports.pefcl:removeBankBalance(source, { amount = vehicleData.VEHICLE_PRICE, message = ('Zakoupení vozidla %s'):format(vehicleData.label) })
            return result.status == 'ok' or false
        else
            return exports.ox_inventory:RemoveItem(source, 'money', price)
        end
    end
end

framework.checkLicense = function(source, license)
    if not license then return false end

    local playerIdentifier = framework.getPlayerIdentifier(source)
    if not playerIdentifier then return false end

    local result = db.select('SELECT `type` FROM `user_licenses` WHERE `owner` = ? AND `type` = ?', { playerIdentifier, license })
    if not result then
        lib.notify(source, {
            title = Config.vehicleShops[shopIndex].SHOP_LABEL,
            description = locale('license'),
            type = 'warning'
        })
    end
    return next(result) and true or false
end

return framework