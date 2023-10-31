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


return { create = create }