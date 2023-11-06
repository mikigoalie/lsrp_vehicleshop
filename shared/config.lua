Config = {}

--[[ Main section ]]--
Config.debug = true
Config.useFrontEndSounds = true -- Whether you want usage of sound fx
Config.cacheIndexes = true      -- Menu select indexes will save upon closing menu
Config.menuPosition = 'right'   -- OX Menu pos
Config.textDistance = 1.0       -- Text UI distance
Config.notifDuration = 10000    -- Default notif duration
Config.oxTarget = false
Config.logging = 'https://discord.com/api/webhooks/1168648895203639306/7HgonEmJVPWhPpmwjef869ajO6dH5eYQWG3PhbFo8on3o223w1aNlie7JzdPlJkT5xv5' -- oxlogger or 'YOUR_WEBHOOK'


--[[ Vehicle shops configuration ]]--
Config.vehicleShops = {
    {
        SHOP_LABEL = 'Deluxe Motorsport',
        MENU_ICON = 'fa-solid fa-car',
        SHOP_COORDS = vec3(-32.7748, -1095.4304, 27.2744), 
        PREVIEW_COORDS = vec4(-47.6072, -1092.1250, 26.7543, 90.0), 
        PURCHASED_VEHICLE_SPAWNS = vec4(-23.6204, -1094.3016, 27.0452, 339.1980),
        VEHICLE_LIST = 'vehicles',
        BLIP_DATA = {color = 5, sprite = 810, scale = 0.8},
        NPC_DATA = {model = joaat('IG_Avon'), position = vec4(-30.7224, -1096.5004, 26.2744, 68.4467)},
        SHOWCASE_VEHICLES = {
            {SHOWCASE_VEHICLE_MODEL = joaat('cypher'), coords = vec4(-53.7864, -1117.4386, 26.0897, 158.8436), color = {255, 128, 32}},
            {SHOWCASE_VEHICLE_MODEL = joaat('tenf'), coords = vec4(-60.7932, -1118.0017, 26.0886, 160.2876)},
            {SHOWCASE_VEHICLE_MODEL = joaat('drafter'), coords = vec4(-50.3500, -1117.2529, 26.0890, 156.5067), color = {'chameleon', 175}},
        }
    },
    {
        SHOP_LABEL = 'Port of LS',
        MENU_ICON = 'fa-solid fa-anchor',
        SHOP_COORDS = vec3(-332.4889, -2792.6875, 5.0002), 
        PREVIEW_COORDS = vec4(-315.2095, -2811.3174, -1.4862, 236.3378), 
        PURCHASED_VEHICLE_SPAWNS = vec4(-295.9564, -2763.7126, -1.0662, 73.7579),
        VEHICLE_LIST = 'boats',
        BLIP_DATA = {color = 5, sprite = 755, scale = 0.8},
        NPC_DATA = {model = joaat('A_M_M_HasJew_01'), position = vec4(-331.8239, -2792.7698, 4.0002, 90.6536)},
        license = 'flight'
    },
    {
        SHOP_LABEL = 'Elitás Travel',
        MENU_ICON = 'fa-solid fa-plane-departure',
        SHOP_COORDS = vec3(1746.7318, 3296.3875, 41.1424), 
        PREVIEW_COORDS = vec4(1728.4298, 3313.7102, 41.2235, 195.8193), 
        PURCHASED_VEHICLE_SPAWNS = vec4(1770.8486, 3238.9597, 42.1628, 32.3031),
        VEHICLE_LIST = 'planes',
        BLIP_DATA = {color = 5, sprite = 755, scale = 0.8},
        NPC_DATA = {model = joaat('A_M_M_HasJew_01'), position = vec4(1746.7318, 3296.3875, 40.1424, 166.0)},
        --license = 'flight'
    },
}