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


local lastCoords = vec4(0, 0, 0, 0.0)
local function setLastCoords()
    local coords = GetEntityCoords(cache.ped)
    lastCoords = vec4(coords.x, coords.y, coords.z - 1, GetEntityHeading(cache.ped))
end

local function teleportPlayerToLastPos()
    SetEntityCoords(cache.ped, lastCoords.xyz)
    SetEntityHeading(cache.ped, lastCoords.w)
end

return {
    hex2rgb = hex2rgb,
    groupDigs = groupDigs,
    fadeOut = fadeOut,
    fadeIn = fadeIn,
    dprint = dprint,
    setLastCoords = setLastCoords,
    teleportPlayerToLastPos = teleportPlayerToLastPos
}