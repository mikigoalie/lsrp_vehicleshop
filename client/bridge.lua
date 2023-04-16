if GetResourceState('es_extended') == 'started' then
    local function GeneratePlate()
        return lib.callback.await('lsrp_vehicleShop:server:generateplate', false)
    end 
    exports('GeneratePlate', GeneratePlate)
end
