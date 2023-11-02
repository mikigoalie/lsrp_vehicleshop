local function create(model, coords)
    lib.print.info(('Create NPC Coords: %s'):format(coords))
    lib.requestModel(model)
    local npcHandle = CreatePed(5, model, coords.x, coords.y, coords.z, coords.w, false, true)
    FreezeEntityPosition(npcHandle, true)
    SetEntityInvincible(npcHandle, true)
    SetBlockingOfNonTemporaryEvents(npcHandle, true)
    SetPedCanBeTargetted(npcHandle, false)
    SetEntityAsMissionEntity(npcHandle, true, true)
    TaskStartScenarioInPlace(npcHandle, 'WORLD_HUMAN_GUARD_STAND')
    return npcHandle
end

local function deleteFromVeh(vehicle)
    for i = -1, 10 do   -- I could get GetVehicleModelNumberOfSeats but fuck it, i dont think it matters anyway
        local vehiclePed = GetPedInVehicleSeat(vehicle, i)
        if vehiclePed ~= cache.ped and vehiclePed > 0 and NetworkGetEntityOwner(vehiclePed) == cache.playerId then
            SetEntityAsMissionEntity(vehiclePed)
            DeleteEntity(vehiclePed)
        end
    end
end

return { create = create, delete = delete, deleteFromVeh = deleteFromVeh }