return function(properties, i)
    if not properties then return false end

    properties.handle = CreateVehicle(properties.vehicleModel, properties.coords.xyz, properties.coords.w, false, false)

    SetEntityAsMissionEntity(properties.handle)
    SetVehicleDoorsLocked(properties.handle, 2)
    SetVehicleUndriveable(properties.handle, true)
    SetVehicleDoorsLockedForAllPlayers(properties.handle, true)
    SetVehicleNumberPlateText(properties.handle, ('SHWCS%s'):format(i))
    SetVehicleWindowTint(properties.handle, 3)
    SetEntityInvincible(properties.handle, true)
    SetVehicleInteriorlight(properties.handle, true)
    SetVehicleDirtLevel(properties.handle, 0.0)
    FreezeEntityPosition(properties.handle, true)
    SetVehicleHasUnbreakableLights(properties.handle, true)
    SetDisableVehicleWindowCollisions(properties.handle, true)
    if properties.color[1] == 'chameleon' then
        SetVehicleModKit(properties.handle, 0)
        SetVehicleColours(properties.handle, properties.color[2], properties.color[2])
    else
        SetVehicleCustomPrimaryColour(properties.handle, properties.color[1] or 255, properties.color[2] or 0, properties.color[3] or 0)
    end

    return properties.handle
end