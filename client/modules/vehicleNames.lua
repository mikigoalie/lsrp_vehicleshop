local utils = require('client.modules.utils')
local classes = require('client.modules.classes')
local function generate()
    local generated = 0
    for class, data in pairs(Config.VEHICLE_LIST) do
        for _, classData in ipairs(data) do
            for _, vehData in ipairs(classData.values) do
                if not classData.icon then
                    classData.icon = classes[tonumber(GetVehicleClassFromName(vehData.VEHICLE_MODEL))].icon
                end

                if not vehData.label then
                    generated = generated + 1

                    vehData.label = GetDisplayNameFromVehicleModel(vehData.VEHICLE_MODEL):upper()
                    local lastChar = vehData.label:sub(-1)
                    if tonumber(lastChar) then
                        vehData.label = ('%s %s'):format(vehData.label:sub(1, -2), lastChar)
                    end
                end
            end
        end
    end

    utils.dprint(('%s'):format(generated > 0 and ("Generated labels for %s vehicles"):format(generated) or "All vehicles have label assigned"))
end CreateThread(generate)