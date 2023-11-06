local db = {}

-- Add a vehicle to the database.

---@param {Object} data
---@param {string} data.identifier
---@param {string} data.plate
---@param {string} data.properties - Already json.
---@param {string} data.hasFreeCoords - Boolean.
---@param {string} data.vehicleType - A vehicle type for database, ESX specific.
---@param {string} data.vehicleName - A name of the vehicle.

db.addVehicle = function(data)
    return MySQL.insert.await('INSERT INTO owned_vehicles (`owner`, `plate`, `vehicle`, `stored`, `type`, `name`) VALUES (?, ?, ?, ?, ?, ?)', {data.identifier, data.plate, data.properties, not hasFreeCoords, data.vehicleType, data.vehicleName})
end

db.select = function(query, params)
    return MySQL.query.await(query, params)
end

return db