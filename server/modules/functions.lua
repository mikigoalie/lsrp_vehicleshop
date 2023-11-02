local db = require('server.modules.database')
local function SendWebHook(text)
    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = 4521728,
            ["title"] = 'A player purchased vehicle!',
            ["description"] = text,
            ["footer"] ={
                ["text"] = timestamp.." (Server Time).",
            },
        }
    }
    PerformHttpRequest(Config.logging,
    function(err, text, headers)end, 'POST', json.encode({username = GetCurrentResourceName(), embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end

local functions = {}
functions.checkLicense = function(source, license)
    if not license then return false end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local result = db.select('SELECT `type` FROM `user_licenses` WHERE `owner` = ? AND `type` = ?', { xPlayer.identifier, license })
    return next(result) and true or false
end


functions.log = function(text)
    if Config.logging == 'oxlogger' then
        lib.logger(source, 'Vehicleshop', json.encode(text))
    else
        SendWebHook(json.encode(text))
    end
end

return functions