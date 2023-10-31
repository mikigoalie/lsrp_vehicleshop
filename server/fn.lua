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

function log(text)
    if Config.logging == 'oxlogger' then
        lib.logger(source, 'Vehicleshop', json.encode(text))
    else
        SendWebHook(json.encode(text))
    end
end

function getBankMoney(source)
    return exports.pefcl:getDefaultAccountBalance(source).data
end

function payBank(source, vehicleData)
    local result = exports.pefcl:removeBankBalance(source, { amount = vehicleData.vehiclePrice, message = ('Zakoupení vozidla %s'):format(vehicleData.label) })
    return result.status == 'ok' or false
end