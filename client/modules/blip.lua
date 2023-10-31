local function createBlip(data)
    local blip = AddBlipForCoord(data.shopCoords.xyz)
    SetBlipSprite(blip, data.blipData?.sprite or 810)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.blipData?.scale)
    SetBlipColour(blip, data.blipData?.color or 2)
    SetBlipSecondaryColour(blip, 255, 0, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.shopLabel)
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