local plate = require('server.modules.plate')
lib.callback.register('lsrp_vehicleShop:server:generateplate', function(source)
    return plate.getPlate()
end)


