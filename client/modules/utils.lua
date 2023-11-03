local function hex2rgb(hex)
    local hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

local function groupDigs(number, separator)
    local left,num,right = string.match(number,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1' .. (seperator or ',')):reverse())..right
end

local function fadeOut(duration)
    DoScreenFadeOut(duration or 500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
end

local function fadeIn(duration)
    DoScreenFadeIn(duration or 1000)
end

local function dprint(text, debugLevel)
    if not text then
        return
    end


    debugLevel = debugLevel or "debug"

    print(('^6[LSRP_Vehicleshop]: ^6%s^7'):format(text))
end


local lastCoords = false
local function setLastCoords()
    local coords = GetEntityCoords(cache.ped)
    lastCoords = vec4(coords.x, coords.y, coords.z - 1, GetEntityHeading(cache.ped))
end

local function teleportPlayerToLastPos()
    if not lastCoords then return end

    SetEntityCoords(cache.ped, lastCoords.xyz)
    SetEntityHeading(cache.ped, lastCoords.w)
end

local function deleteLocalVehicle(handle)
    if handle then
        SetVehicleAsNoLongerNeeded(handle)
        SetEntityAsMissionEntity(handle)
        DeleteVehicle(handle)
    end

	return DoesEntityExist(handle) and true
end

local function loadModel(model)
    if not IsModelInCdimage(model) then return false end
    local modelLoaded = lib.requestModel(model)
    if not modelLoaded then return false end
    return true
end

local function setVehicleProperties(vehicle)
    if GetVehicleDoorLockStatus(vehicle) ~= 4 then
        SetVehicleDoorsLocked(vehicle, 4)
    end

    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleHandbrake(vehicle, true)
    SetVehicleInteriorlight(vehicle, true)

    if GetVehicleClass(vehicle) == 14 then
        SetBoatAnchor(vehicle, true)
        SetBoatFrozenWhenAnchored(vehicle, true)
    else
        FreezeEntityPosition(vehicle, true)
    end

    if GetVehicleClass(vehicle) == 15 or GetVehicleClass(vehicle) == 16 then
        SetHeliMainRotorHealth(vehicle, 0)
    end
end



return {
    hex2rgb = hex2rgb,
    groupDigs = groupDigs,
    fadeOut = fadeOut,
    fadeIn = fadeIn,
    dprint = dprint,
    setLastCoords = setLastCoords,
    teleportPlayerToLastPos = teleportPlayerToLastPos,
    deleteLocalVehicle = deleteLocalVehicle,
    loadModel = loadModel,
    setVehicleProperties = setVehicleProperties
}