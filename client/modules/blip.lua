local function createBlip(data)
    local blip = AddBlipForCoord(data.SHOP_COORDS.xyz)
    SetBlipSprite(blip, data.BLIP_DATA?.sprite or 810)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.BLIP_DATA?.scale)
    SetBlipColour(blip, data.BLIP_DATA?.color or 2)
    SetBlipSecondaryColour(blip, 255, 0, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.SHOP_LABEL)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function removeBlip(blip)
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

return {
    createBlip = createBlip,
    removeBlip = removeBlip
}