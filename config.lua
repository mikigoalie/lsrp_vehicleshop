Config = {}
--[[ Main section ]]--
Config.menuPosition = 'right'
Config.textDistance = 1.0
Config.notifDuration = 10000
Config.usePEFCL = true -- if false it will use ox/esx default money logic
Config.oxTarget = false
Config.logging = 'oxlogger' -- oxlogger or 'YOUR_WEBHOOK'
Config.vehicleColors = {    -- Allow custom RGB Colors for primary and secondary? Currently without any money take
    primary = true,
    secondary = true
}



--[[ Vehicle shops configuration ]]--
Config.vehicleShops = {
    --[[
        shopLabel = This is label of the shop
        shopCoords = Shop point coords (also for blip)
        previewCoords = Where will the vehicle spawn? Vec4!
        vehicleSpawnCoords = When you buy the vehicle, where should it spawn? Vec4! (If not empty, it will be added to the garage)
        vehicleList = String 'car, boats, airplane' to be compatible with your garages
        blipData = Example: {color = 5, sprite = 755, scale = 0.8},
        npcData = Example: {model = joaat('A_M_M_HasJew_01'), position = vec4(-331.8239, -2792.7698, 4.0002, 90.6536)},
        license = String 'dmv', 'boat' whatever you have for your license system (look in db)
    --]]

    {
        shopLabel = 'Deluxe Motorsport',
        shopIcon = 'fa-solid fa-car',
        shopCoords = vec3(-32.7748, -1095.4304, 27.2744), 
        previewCoords = vec4(-47.6072, -1092.1250, 26.7543, 90.0), 
        vehicleSpawnCoords = vec4(-23.6204, -1094.3016, 27.0452, 339.1980),
        job = 'cardealer',
        vehicleList = 'vehicles',
        blipData = {color = 5, sprite = 810, scale = 0.8},
        npcData = {model = joaat('IG_Avon'), position = vec4(-30.7224, -1096.5004, 26.2744, 68.4467)},
        showcaseVehicle = {
            {vehicleModel = joaat('kanjo'), coords = vec4(-49.8157, -1083.6610, 26.23, 199.9693), color = {255, 128, 32}},
            {vehicleModel = joaat('tenf2'), coords = vec4(-54.7802, -1096.9150, 26.1577, 297.9555), color = {255, 0, 32}},
            {vehicleModel = joaat('rhinehart'), coords = vec4(-42.3705, -1101.3069, 26.5423, 350.3064), color = {255, 0, 32}},
            {vehicleModel = joaat('ztype'), coords = vec4(-36.6870, -1093.3662, 26.2255, 153.1380), color = {255, 0, 32}},
        }
    },
    {
        shopLabel = 'Port of LS',
        shopIcon = 'fa-solid fa-anchor',
        shopCoords = vec3(-332.4889, -2792.6875, 5.0002), 
        previewCoords = vec4(-315.2095, -2811.3174, -1.4862, 236.3378), 
        vehicleSpawnCoords = vec4(-295.9564, -2763.7126, -1.0662, 73.7579),
        job = false,
        vehicleList = 'boats',
        blipData = {color = 5, sprite = 755, scale = 0.8},
        npcData = {model = joaat('A_M_M_HasJew_01'), position = vec4(-331.8239, -2792.7698, 4.0002, 90.6536)},
        license = 'flight'
    },
    {
        shopLabel = 'Elitás Travel',
        shopIcon = 'fa-solid fa-plane-departure',
        shopCoords = vec3(1746.7318, 3296.3875, 41.1424), 
        previewCoords = vec4(1728.4298, 3313.7102, 41.2235, 195.8193), 
        vehicleSpawnCoords = vec4(1770.8486, 3238.9597, 42.1628, 32.3031),
        job = false,
        vehicleList = 'planes',
        blipData = {color = 5, sprite = 755, scale = 0.8},
        npcData = {model = joaat('A_M_M_HasJew_01'), position = vec4(1746.7318, 3296.3875, 40.1424, 166.0)},
        license = 'flight'
    },
}

Config.vehicleList = {
    ['vehicles'] = {
        {label = 'compacts', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Brioso', vehicleModel = joaat('brioso'), vehiclePrice = 3400},
            {label = 'BriosoB', vehicleModel = joaat('brioso2'), vehiclePrice = 3100}, 
            {label = 'Club', vehicleModel = joaat('club'), vehiclePrice = 2800}, 
            {label = 'Issi', vehicleModel = joaat('issi2'), vehiclePrice = 2900},
            {label = 'IssiB', vehicleModel = joaat('issi4'), vehiclePrice = 3600},
            {label = 'IssiC', vehicleModel = joaat('issi5'), vehiclePrice = 4200},
        }},
        {label = 'coupes', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Felon', vehicleModel = joaat('felon'), vehiclePrice = 60000}, 
            {label = 'FelonB', vehicleModel = joaat('felon2'), vehiclePrice = 65000}, 
            {label = 'Oracle', vehicleModel = joaat('oracle2'), vehiclePrice = 70000},
            {label = 'Windsor', vehicleModel = joaat('windsor'), vehiclePrice = 100000}, 
            {label = 'WindsorB', vehicleModel = joaat('windsor2'), vehiclePrice = 100000},
            {label = 'Zion', vehicleModel = joaat('zion2'), vehiclePrice = 85000},
            {label = 'Ocelot', vehicleModel = joaat('f620'), vehiclePrice = 72000},
        }},
        {label = 'muscles', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Buccaneer', vehicleModel = joaat('buccaneer'), vehiclePrice = 1200}, 
            {label = 'Phoenix', vehicleModel = joaat('phoenix'), vehiclePrice = 1400}, 
            {label = 'Faction', vehicleModel = joaat('faction'), vehiclePrice = 1600},
            {label = 'Gauntlet', vehicleModel = joaat('gauntlet'), vehiclePrice = 1800},
            {label = 'Moonbeam', vehicleModel = joaat('moonbeam'), vehiclePrice = 2000},
            {label = 'Sabre', vehicleModel = joaat('sabregt'), vehiclePrice = 2200},
            {label = 'Dominator', vehicleModel = joaat('dominator'), vehiclePrice = 2400},
            {label = 'Tampa', vehicleModel = joaat('tampa'), vehiclePrice = 2600},
            {label = 'Virgo', vehicleModel = joaat('virgo'), vehiclePrice = 1000},
            {label = 'Voodoo', vehicleModel = joaat('voodoo'), vehiclePrice = 1000},
            {label = 'VoodooB', vehicleModel = joaat('voodoo2'), vehiclePrice = 1000},
            {label = 'Vamos', vehicleModel = joaat('vamos'), vehiclePrice = 1000},
            {label = 'Hermes', vehicleModel = joaat('hermes'), vehiclePrice = 1000},
            {label = 'Tahoma', vehicleModel = joaat('tahoma'), vehiclePrice = 1000},
        }},
        {label = 'offroads', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Bfinjection', vehicleModel = joaat('bfinjection'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Bifta', vehicleModel = joaat('bifta'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Bodhi', vehicleModel = joaat('bodhi2'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Caracara', vehicleModel = joaat('caracara2'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Dubsta 6x6', vehicleModel = joaat('dubsta3'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Everon', vehicleModel = joaat('everon'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Hellion', vehicleModel = joaat('hellion'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Kamacho', vehicleModel = joaat('kamacho'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Rebel', vehicleModel = joaat('Rebel'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'RancherXL', vehicleModel = joaat('rancherxl'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Sandking', vehicleModel = joaat('sandking'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Trophytruck', vehicleModel = joaat('trophytruck'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Vagrant', vehicleModel = joaat('vagrant'), vehiclePrice = 1000, description = vehiclePrice},
        }},
        {label = 'suvs', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Baller', vehicleModel = joaat('baller'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Cavalcade', vehicleModel = joaat('cavalcade'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Contender', vehicleModel = joaat('contender'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Dubsta', vehicleModel = joaat('dubsta'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Granger', vehicleModel = joaat('granger'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Gresley', vehicleModel = joaat('gresley'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Huntley', vehicleModel = joaat('huntley'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Landstalker', vehicleModel = joaat('landstalker'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Novak', vehicleModel = joaat('novak'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Mesa', vehicleModel = joaat('mesa'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Patriot', vehicleModel = joaat('patriot'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Rebla', vehicleModel = joaat('rebla'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Rocoto', vehicleModel = joaat('rocoto'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Seminole', vehicleModel = joaat('seminole'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Serrano', vehicleModel = joaat('serrano'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Toros', vehicleModel = joaat('toros'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Benefactor XLS', vehicleModel = joaat('xls'), vehiclePrice = 1000, description = vehiclePrice},
        }},
        {label = 'sedans', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Emperor', vehicleModel = joaat('emperor'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Emperor', vehicleModel = joaat('emperor2'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Asea', vehicleModel = joaat('asea'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Asterope', vehicleModel = joaat('asterope'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Cognoscenti', vehicleModel = joaat('cognoscenti'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Glendale', vehicleModel = joaat('glendale'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Intruder', vehicleModel = joaat('intruder'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Premier', vehicleModel = joaat('premier'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Primo', vehicleModel = joaat('primo'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Regina', vehicleModel = joaat('regina'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Stanier', vehicleModel = joaat('stanier'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Stratum', vehicleModel = joaat('stratum'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Tailgater', vehicleModel = joaat('tailgater'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Warrener', vehicleModel = joaat('warrener'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Washington', vehicleModel = joaat('washington'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Surge', vehicleModel = joaat('surge'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Super Diamond', vehicleModel = joaat('superd'), vehiclePrice = 1000, description = vehiclePrice},
        }},
        {label = 'sports', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Alpha', vehicleModel = joaat('alpha'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Banshee', vehicleModel = joaat('banshee'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Bestia GTS', vehicleModel = joaat('bestiagts'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Buffalo', vehicleModel = joaat('buffalo'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Carbonizzare', vehicleModel = joaat('carbonizzare'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Coquette', vehicleModel = joaat('coquette'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Drafter', vehicleModel = joaat('drafter'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Deveste', vehicleModel = joaat('deveste'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Elegy', vehicleModel = joaat('elegy'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Flash GT', vehicleModel = joaat('flashgt'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Fusilade', vehicleModel = joaat('fusilade'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Furore GT', vehicleModel = joaat('furoregt'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Karin Futo', vehicleModel = joaat('futo'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Komoda', vehicleModel = joaat('komoda'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Imorgon', vehicleModel = joaat('imorgon'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Jugular', vehicleModel = joaat('jugular'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Jester', vehicleModel = joaat('jester'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Kuruma', vehicleModel = joaat('kuruma'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Lynx', vehicleModel = joaat('lynx'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Neon', vehicleModel = joaat('neon'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'NineF', vehicleModel = joaat('ninef'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Omnis', vehicleModel = joaat('omnis'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Schwarzer', vehicleModel = joaat('schwarzer'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Specter', vehicleModel = joaat('specter'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Italirsx', vehicleModel = joaat('italirsx'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Zr350', vehicleModel = joaat('zr350'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Calico', vehicleModel = joaat('calico'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Euros', vehicleModel = joaat('euros'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Growler', vehicleModel = joaat('growler'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Cypher', vehicleModel = joaat('cypher'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'RT3000', vehicleModel = joaat('rt3000'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Vectre', vehicleModel = joaat('vectre'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Sultan', vehicleModel = joaat('sultan'), vehiclePrice = 1000, description = vehiclePrice},
        }},
        {label = 'classics', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Ardent', vehicleModel = joaat('ardent'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Casco', vehicleModel = joaat('casco'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Michelli', vehicleModel = joaat('michelli'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Nebula', vehicleModel = joaat('nebula'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Manana', vehicleModel = joaat('manana'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Mamba', vehicleModel = joaat('mamba'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Retinue', vehicleModel = joaat('retinue'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Stinger', vehicleModel = joaat('stinger'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Tornado', vehicleModel = joaat('tornado'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Torero', vehicleModel = joaat('torero'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Viseris', vehicleModel = joaat('viseris'), vehiclePrice = 1000, description = vehiclePrice},
        }},
        {label = 'supers', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Addert', vehicleModel = joaat('adder'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Cheetah', vehicleModel = joaat('cheetah'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Emerus', vehicleModel = joaat('emerus'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Krieger', vehicleModel = joaat('krieger'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'ItaliGTB', vehicleModel = joaat('italigtb'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Infernus', vehicleModel = joaat('infernus'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Penetrator', vehicleModel = joaat('penetrator'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Sheava', vehicleModel = joaat('sheava'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Turismor', vehicleModel = joaat('turismor'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Visione', vehicleModel = joaat('visione'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Vacca', vehicleModel = joaat('vacca'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Tyrus', vehicleModel = joaat('tyrus'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Tempesta', vehicleModel = joaat('tempesta'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Reaper', vehicleModel = joaat('reaper'), vehiclePrice = 1000, description = vehiclePrice},
        }},
        {label = 'vans', defaultIndex = 2, dbData = 'car', values = {
            {label = 'Burrito', vehicleModel = joaat('burrito'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'GBurrito', vehicleModel = joaat('gburrito'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Journey', vehicleModel = joaat('journey'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Pony', vehicleModel = joaat('pony'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Minivan', vehicleModel = joaat('minivan'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Rumpo', vehicleModel = joaat('rumpo'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Speedo', vehicleModel = joaat('speedo'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Surfer', vehicleModel = joaat('surfer'), vehiclePrice = 1000, description = vehiclePrice},
       }},
        
    },
    ['boats'] = {
        {label = 'Skůtry', defaultIndex = 2, dbData = 'boat', values = {
            {label = 'Seashark', vehicleModel = joaat('seashark'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Seashark', vehicleModel = joaat('seashark2'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Seashark', vehicleModel = joaat('seashark3'), vehiclePrice = 1000, description = vehiclePrice},
        }},
        {label = 'Čluny', defaultIndex = 2, dbData = 'boat', values = {
            {label = 'Dinghy', vehicleModel = joaat('dinghy'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'DinghyB', vehicleModel = joaat('dinghy2'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'DinghyC', vehicleModel = joaat('dinghy3'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'DinghyD', vehicleModel = joaat('dinghy4'), vehiclePrice = 1000, description = vehiclePrice}, 
        }},
        {label = 'Výletní čluny', defaultIndex = 2, dbData = 'boat', values = {
            {label = 'Jetmax', vehicleModel = joaat('jetmax'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'Speeder', vehicleModel = joaat('speeder'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'SpeederB', vehicleModel = joaat('speeder2'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Squalo', vehicleModel = joaat('squalo'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Suntrap', vehicleModel = joaat('suntrap'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Toro', vehicleModel = joaat('toro'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'ToroB', vehicleModel = joaat('toro2'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Tropic', vehicleModel = joaat('tropic'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'TropicB', vehicleModel = joaat('tropic2'), vehiclePrice = 1000, description = vehiclePrice},
            {label = 'Longfin', vehicleModel = joaat('longfin'), vehiclePrice = 1000, description = vehiclePrice},
       }},
    },
    ['planes'] = {
        {label = 'Helikoptéry', defaultIndex = 2, dbData = 'plane', values = {
            {label = 'havok', vehicleModel = joaat('havok'), vehiclePrice = 1000, description = vehiclePrice}, 
            {label = 'nokota', vehicleModel = joaat('nokota'), vehiclePrice = 1000, description = vehiclePrice}, 
        }},
    },

}
