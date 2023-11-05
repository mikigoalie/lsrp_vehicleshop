local function getVehicle(shopIdx, selectIdx, scrollIdx)
    return Config.VEHICLE_LIST[Config.vehicleShops[shopIdx].VEHICLE_LIST][selectIdx].values[scrollIdx]
end

local function getShop(shopIdx)
    return Config.vehicleShops[shopIdx]
end

return {
    getVehicle = getVehicle,
    getShop = getShop
}