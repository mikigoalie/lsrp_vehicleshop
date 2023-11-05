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
Config.vehicleColors = {    -- Allow custom RGB Colors for primary and secondary? Currently without any money take
    primary = true,
    secondary = true
}



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
            {SHOWCASE_VEHICLE_MODEL = joaat('oracxsle'), coords = vec4(-49.8157, -1083.6610, 26.23, 199.9693), color = {255, 128, 32}},
            {SHOWCASE_VEHICLE_MODEL = joaat('cypherct'), coords = vec4(-54.7802, -1096.9150, 26.1577, 297.9555)},
            {SHOWCASE_VEHICLE_MODEL = joaat('argento'), coords = vec4(-42.3705, -1101.3069, 26.5423, 350.3064), color = {'chameleon', 175}},
            {SHOWCASE_VEHICLE_MODEL = joaat('sunrise1'), coords = vec4(-36.6870, -1093.3662, 26.2255, 153.1380), color = {'chameleon', 161}},
        }
    },

    {
        SHOP_LABEL = 'Premium Deluxe Motorsport',
        MENU_ICON = 'fa-solid fa-car',
        SHOP_COORDS = vec3(-1256.6936, -367.5191, 36.9074), 
        PREVIEW_COORDS = vec4(-1255.8885, -354.4863, 36.6496, 69.0134), 
        PURCHASED_VEHICLE_SPAWNS = vec4(-1234.7506, -352.5141, 36.9216, 348.5213),
        VEHICLE_LIST = 'vehicles',
        BLIP_DATA = {color = 5, sprite = 810, scale = 0.8},
        NPC_DATA = {model = joaat('IG_Avon'), position = vec4(-1257.3900, -369.1119, 35.9076, 326.1691)},
        SHOWCASE_VEHICLES = {
            {SHOWCASE_VEHICLE_MODEL = joaat('nero2'), coords = vec4(-1270.0524, -358.4790, 36.4939, 248.8551), color = {255, 128, 32}},
            {SHOWCASE_VEHICLE_MODEL = joaat('tempesta'), coords = vec4(-1269.1307, -364.7496, 36.4321, 296.3736), color = {255, 0, 32}},
            {SHOWCASE_VEHICLE_MODEL = joaat('t20'), coords = vec4(-1265.2803, -354.4835, 36.4840, 209.07534), color = {255, 0, 32}},
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