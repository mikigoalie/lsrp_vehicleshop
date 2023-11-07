Config = {}

--[[ Main section ]]--
---@type string "esx" | "pefcl" | server/bridge/framework.lua
Config.payment = "esx"                  -- 
Config.debug = true
Config.vehicleTable = "owned_vehicles"
Config.useFrontEndSounds = true         -- Whether you want usage of sound fx
Config.cacheIndexes = true              -- Menu select indexes will save upon closing menu
Config.menuPosition = 'right'           -- OX Menu pos
Config.textDistance = 1.0               -- Text UI distance
Config.notifDuration = 10000            -- Default notif duration
Config.oxTarget = false
Config.logging = 'https://discord.com/api/webhooks/1168648895203639306/7HgonEmJVPWhPpmwjef869ajO6dH5eYQWG3PhbFo8on3o223w1aNlie7JzdPlJkT5xv5' -- oxlogger or 'YOUR_WEBHOOK'


--[[ Vehicle shops configuration ]]--

---@type Array
---@type array.SHOP_LABEL string
---@type array.MENU_ICON Font Awesome Icons
---@type array.SHOP_COORDS Vector3 - Center of the shop
---@type array.PREVIEW_COORDS Vector4 - Shop entrance / exit
---@type array.PURCHASED_VEHICLE_SPAWNS Vector4 | Array - Coords for purchased vehicle to spawn
---@type array.VEHICLE_LIST string - specified vehicleList.lua array

---@type array.BLIP_DATA array - specified vehicleList.lua array
---@type array.BLIP_DATA.color number - color
---@type array.BLIP_DATA.sprite number - sprite
---@type array.BLIP_DATA.scale number - scale

---@type array.NPC_DATA.model joaat(model) - NPC Model
---@type array.NPC_DATA.position Vector4

---@type array.SHOWCASE_VEHICLES Array
---@type array.SHOWCASE_VEHICLES.SHOWCASE_VEHICLE_MODEL joaat(model)
---@type array.SHOWCASE_VEHICLES.coords Vector4
---@type array.SHOWCASE_VEHICLES.color?[1] Red | 'chameleon'
---@type array.SHOWCASE_VEHICLES.color?[2] Green | chameleon color number
---@type array.SHOWCASE_VEHICLES.color?[3] Blue

---@type array.SHOWCASE_VEHICLES.license? string - License to own when purchasing

Config.vehicleShops = {
    {
        SHOP_LABEL = 'Deluxe Motorsport',
        MENU_ICON = 'fa-solid fa-car',
        SHOP_COORDS = vec3(-32.7748, -1095.4304, 27.2744), 
        PREVIEW_COORDS = vec4(-47.6072, -1092.1250, 26.7543, 90.0), 
        PURCHASED_VEHICLE_SPAWNS = {vec4(-10.0278, -1095.0568, 27.0321, 178.7414), vec4(-14.3705, -1108.2189, 26.9248, 158.5954)},
        VEHICLE_LIST = 'vehicles',
        BLIP_DATA = {color = 5, sprite = 810, scale = 0.8},
        NPC_DATA = {model = joaat('IG_Avon'), position = vec4(-30.7224, -1096.5004, 26.2744, 68.4467)},
        SHOWCASE_VEHICLES = {
            {SHOWCASE_VEHICLE_MODEL = joaat('adder'), coords = vec4(-42.3511, -1101.5804, 26.7262, 356.4317), color = {255, 128, 32}},
            {SHOWCASE_VEHICLE_MODEL = joaat('zentorno'), coords = vec4(-37.0104, -1092.8065, 26.8779, 177.5585)},
            {SHOWCASE_VEHICLE_MODEL = joaat('blista'), coords = vec4(-49.9161, -1083.1125, 27.1248, 201.3450)},
            {SHOWCASE_VEHICLE_MODEL = joaat('exemplar'), coords = vec4(-54.6393, -1096.9513, 27.1250, 303.4448)},
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
        license = 'boat',
        SHOWCASE_VEHICLES = {
            {SHOWCASE_VEHICLE_MODEL = joaat('tug'), coords = vec4(-306.5132, -2806.1492, -0.9544, 283.8846), color = {255, 128, 32}},
        }
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