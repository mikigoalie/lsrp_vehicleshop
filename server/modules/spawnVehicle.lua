return function(vehicleModel, spawnCoords, properties, playerIdentifier)
    ESX.OneSync.SpawnVehicle(vehicleModel, spawnCoords.xyz, spawnCoords?.w or 0.0, properties, function(NetworkId)
        Wait(100)
        local Vehicle = NetworkGetEntityFromNetworkId(NetworkId)
        if DoesEntityExist(Vehicle) then
            SetVehicleDoorsLocked(Vehicle, 1)
            local _vehicleState = Entity(Vehicle).state
            _vehicleState:set('owner', playerIdentifier:sub(1, 10), true)
        end
    end)
end