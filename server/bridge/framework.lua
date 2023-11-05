local db = require('server.modules.database')
local framework = {}
framework.getPlayer = function(playerId)
    return ESX.GetPlayerFromId(playerId)
end

framework.getPlayerIdentifier = function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId) 
    return xPlayer and xPlayer.identifier or false
end

framework.getCash = function()

end

framework.getBankBalance = function(source)
    return exports.pefcl:getDefaultAccountBalance(source).data
end

framework.paymentBANK = function(source, vehicleData)
    local result = exports.pefcl:removeBankBalance(source, { amount = vehicleData.VEHICLE_PRICE, message = ('Zakoupení vozidla %s'):format(vehicleData.label) })
    return result.status == 'ok' or false
end

framework.paymentCASH = function(source, VEHICLE_PRICE)
    return exports.ox_inventory:RemoveItem(source, 'money', VEHICLE_PRICE)
end

framework.checkLicense = function(source, license)
    if not license then return false end

    local playerIdentifier = framework.getPlayerIdentifier(source)
    if not playerIdentifier then return false end

    local result = db.select('SELECT `type` FROM `user_licenses` WHERE `owner` = ? AND `type` = ?', { playerIdentifier, license })
    return next(result) and true or false
end

return framework