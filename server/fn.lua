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
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.getAccount('bank').money
end

function removeBankMoney(source, vehPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney('bank', vehPrice)
end