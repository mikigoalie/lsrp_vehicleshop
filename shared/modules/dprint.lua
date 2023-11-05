local function dprint(text, debugLevel)
    if not text then
        return
    end


    debugLevel = debugLevel or "debug"

    print(('^6[LSRP_Vehicleshop]: ^6%s^7'):format(text))
end


return dprint