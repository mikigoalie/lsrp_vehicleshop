local utils = require('client.modules.utils')
local menuOptions = {}
local km = 3.6
local miles = 2.236936
menuOptions.getVehicleInfo = function(vehicle, model)
    if not cache.vehicle then return end


    local options = {}
    local MAX_SPEED = GetVehicleEstimatedMaxSpeed(vehicle)
    local SEATS = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
    local PLATE = GetVehicleNumberPlateText(vehicle)

    return { 
        text = ('**Model**: *%s*  \n**Plate**: *%s*  \n**Estimated speed**: *%s km/h*  \n**Number of seats**: *%s*'):format(model, PLATE, math.floor(MAX_SPEED*km), SEATS), 
        options = {
            position = Config.menuPosition == 'right' and 'left-center' or 'right-center',
            style = {
                borderRadius = 5,
                backgroundColor = 'linear-gradient(90deg, rgba(17,17,18,1) 0%, rgba(66,71,71,1) 52%, rgba(83,83,83,1) 100%)',
                color = 'white',
                width = "calc(100% + 10rem)",
            }
        }
    }
end

menuOptions.generateMenuOptions = function(CFG_VEHICLE_CLASS)
    local options = {}

    for classIndex, classInfo in pairs(CFG_VEHICLE_CLASS) do
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
            defaultIndex = classInfo.cachedIndex or 1,
        }
    end


    return options
end

return menuOptions