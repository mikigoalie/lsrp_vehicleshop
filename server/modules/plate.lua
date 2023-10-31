
local model = joaat('adder')
local void_coords = vector3(-787.92, -0.26, -169.97)
local function generatePlate()
    CreateThread( function()
        local timeout = 50
        local vehicle = CreateVehicleServerSetter(`adder`, 'automobile', void_coords.x, void_coords.y, void_coords.z)
        while #GetVehicleNumberPlateText(vehicle) < 1 do
            timeout = timeout - 1
            if timeout <= 0 then break end
            Wait(100)
        end

        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        DeleteEntity(vehicle)
        return #vehiclePlate > 1 and vehiclePlate or false
    end)
end

local function getPlate()
    local freePlate = false
    local str

    repeat
        str = plate.generatePlate()
        freePlate = MySQL.single.await('SELECT `owner` FROM `owned_vehicles` WHERE plate = ?', {str})
    until not freePlate

    return string.upper(str)
end


return {
    generatePlate = generatePlate,
    getPlate = getPlate
}