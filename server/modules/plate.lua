local model = joaat('adder')
local void_coords = vector3(-787.92, -0.26, -169.97)

local function randomChar(set)
    local index = math.random(#set)
    return set:sub(index, index)
end

local function generatePlate()
    local pattern = ESX.GetConfig().CustomAIPlates
    local plate = ""

    for i = 1, #pattern do
        local char = pattern:sub(i, i)
        if char == "1" then
            plate = plate .. tostring(math.random(9))
        elseif char == "A" then
            plate = plate .. randomChar("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        elseif char == "." then
            if math.random() < 0.5 then
                plate = plate .. tostring(math.random(9))
            else
                plate = plate .. randomChar("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            end
        elseif char:sub(1, 1) == "^" then
            plate = plate .. char:sub(2, 2)
        else
            plate = plate .. char
        end
    end

    while #plate < 8 do
        plate = plate .. randomChar("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    end

    return plate
end

local function getPlate()
    local plate = ''
    local freePlate = false

    repeat
        plate = generatePlate()
        freePlate = MySQL.single.await('SELECT `owner` FROM `owned_vehicles` WHERE plate = ?', {plate})
    until not freePlate?.owner

    return string.upper(plate)
end

return {
    generatePlate = generatePlate,
    getPlate = getPlate
}
