-- dbData is used mainly for ESX to get vehicle cat to spawn vehicles etc. Hence why it's here, overriding it will cause vehicles not to be usable

Config.VEHICLE_LIST = {
    ['vehicles'] = {
        {label = locale('helicopters'), dbData = 'plane', values = {
            {VEHICLE_MODEL = joaat('havok'), VEHICLE_PRICE = 1000}, 
            {VEHICLE_MODEL = joaat('nokota'), VEHICLE_PRICE = 1000}, 
        }},
        {label = locale('compacts'), dbData = 'car', values = {
            {label = 'Club', VEHICLE_MODEL = joaat('club'), VEHICLE_PRICE = 22000},
            {label = 'Weevil', VEHICLE_MODEL = joaat('weevil'), VEHICLE_PRICE = 20000},
            {label = 'Brioso 300', VEHICLE_MODEL = joaat('brioso2'), VEHICLE_PRICE = 18000 },
            {label = 'Kanjo', VEHICLE_MODEL = joaat('kanjo'), VEHICLE_PRICE = 30000},
            {label = 'Asbo', VEHICLE_MODEL = joaat('asbo'), VEHICLE_PRICE = 25000},
            {label = 'Blista', VEHICLE_MODEL = joaat('blista'), VEHICLE_PRICE = 32000}, 
            {label = 'Issi Classic', VEHICLE_MODEL = joaat('issi3'), VEHICLE_PRICE = 18000},
            {label = 'Rhapsody', VEHICLE_MODEL = joaat('rhapsody'), VEHICLE_PRICE = 32000},
        }},
        {label = locale('coupes'), dbData = 'car', values = {
            {label = 'Oracle XS', VEHICLE_MODEL = joaat('oracle'), VEHICLE_PRICE = 75000},
            {label = 'Oracle', VEHICLE_MODEL = joaat('oracle2'), VEHICLE_PRICE = 78000},
            {label = 'Zion', VEHICLE_MODEL = joaat('zion'), VEHICLE_PRICE = 82000},
            {label = 'Zion Cabrio', VEHICLE_MODEL = joaat('zion2'), VEHICLE_PRICE = 82000},
            {label = 'Sentinel XS', VEHICLE_MODEL = joaat('sentinel'), VEHICLE_PRICE = 77000},
            {label = 'Sentinel', VEHICLE_MODEL = joaat('sentinel2'), VEHICLE_PRICE = 80000},
            {label = 'Windsor', VEHICLE_MODEL = joaat('windsor'), VEHICLE_PRICE = 95000},
            {label = 'Windsor Drop', VEHICLE_MODEL = joaat('windsor2'), VEHICLE_PRICE = 95000},
            {label = 'Felon', VEHICLE_MODEL = joaat('felon'), VEHICLE_PRICE = 83000},
            {label = 'Felon GT', VEHICLE_MODEL = joaat('felon2'), VEHICLE_PRICE = 85000},
            {label = 'Postlude', VEHICLE_MODEL = joaat('postlude'), VEHICLE_PRICE = 65000}, 
            {label = 'Previon', VEHICLE_MODEL = joaat('previon'), VEHICLE_PRICE = 68000},
            {label = 'F620', VEHICLE_MODEL = joaat('f620'), VEHICLE_PRICE = 92000},
            {label = 'Exemplar', VEHICLE_MODEL = joaat('exemplar'), VEHICLE_PRICE = 90000},
            {label = 'Cognoscenti Cabrio', VEHICLE_MODEL = joaat('cogcabrio'), VEHICLE_PRICE = 70000},
        }},
        {label = locale('sports'), dbData = 'car', values = {
            {label = 'NineF Cabrio', VEHICLE_MODEL = joaat('ninef2'), VEHICLE_PRICE = 310000},
            {label = 'Buffalo S', VEHICLE_MODEL = joaat('buffalo2'), VEHICLE_PRICE = 275000}, 
            {label = 'Itali GTO', VEHICLE_MODEL = joaat('italigto'), VEHICLE_PRICE = 350000}, 
            {label = 'Schlagen GT', VEHICLE_MODEL = joaat('schlagen'), VEHICLE_PRICE = 335000},
            {label = 'Panthere', VEHICLE_MODEL = joaat('panthere'), VEHICLE_PRICE = 295000},
            {label = 'Raiden', VEHICLE_MODEL = joaat('raiden'), VEHICLE_PRICE = 390000},
            {label = 'Neon', VEHICLE_MODEL = joaat('neon'), VEHICLE_PRICE = 385000},
            {label = 'Komoda', VEHICLE_MODEL = joaat('komoda'), VEHICLE_PRICE = 305000},
            {label = 'Elegy Retro Custom', VEHICLE_MODEL = joaat('elegy'), VEHICLE_PRICE = 220000},
            {label = 'Comet Retro Custom', VEHICLE_MODEL = joaat('comet3'), VEHICLE_PRICE = 300000},
            {label = 'Flash GT', VEHICLE_MODEL = joaat('flashgt'), VEHICLE_PRICE = 325000},
            {label = 'EightF Drafter', VEHICLE_MODEL = joaat('drafter'), VEHICLE_PRICE = 315000},
            {label = 'Omnis e-GT', VEHICLE_MODEL = joaat('omnisegt'), VEHICLE_PRICE = 395000},
            {label = 'TenF', VEHICLE_MODEL = joaat('tenf'), VEHICLE_PRICE = 385000},
            {label = 'Comet S2', VEHICLE_MODEL = joaat('comet6'), VEHICLE_PRICE = 345000},
            {label = 'Growler', VEHICLE_MODEL = joaat('growler'), VEHICLE_PRICE = 350000},
            {label = 'ZR350', VEHICLE_MODEL = joaat('zr350'), VEHICLE_PRICE = 215000},
            {label = 'Cypher', VEHICLE_MODEL = joaat('cypher'), VEHICLE_PRICE = 317000},
            {label = 'Itali GTO Stinger TT', VEHICLE_MODEL = joaat('stingertt'), VEHICLE_PRICE = 390000},
            {label = 'Remus', VEHICLE_MODEL = joaat('remus'), VEHICLE_PRICE = 215000},
        }},
    },
    ['boats'] = {
        {label = locale('skis'), dbData = 'boat', values = {
            {label = 'Seashark', VEHICLE_MODEL = joaat('seashark'), VEHICLE_PRICE = 1000}, 
            {label = 'Seashark', VEHICLE_MODEL = joaat('seashark2'), VEHICLE_PRICE = 1000}, 
            {label = 'Seashark', VEHICLE_MODEL = joaat('seashark3'), VEHICLE_PRICE = 1000},
        }},
        {label = locale('boats'), dbData = 'boat', values = {
            {label = 'Dinghy', VEHICLE_MODEL = joaat('dinghy'), VEHICLE_PRICE = 1000}, 
            {label = 'DinghyB', VEHICLE_MODEL = joaat('dinghy2'), VEHICLE_PRICE = 1000}, 
            {label = 'DinghyC', VEHICLE_MODEL = joaat('dinghy3'), VEHICLE_PRICE = 1000},
            {label = 'DinghyD', VEHICLE_MODEL = joaat('dinghy4'), VEHICLE_PRICE = 1000}, 
        }},
        {label = locale('cruise_boats'), dbData = 'boat', values = {
            {label = 'Jetmax', VEHICLE_MODEL = joaat('jetmax'), VEHICLE_PRICE = 1000}, 
            {label = 'Speeder', VEHICLE_MODEL = joaat('speeder'), VEHICLE_PRICE = 1000}, 
            {label = 'SpeederB', VEHICLE_MODEL = joaat('speeder2'), VEHICLE_PRICE = 1000},
            {label = 'Squalo', VEHICLE_MODEL = joaat('squalo'), VEHICLE_PRICE = 1000},
            {label = 'Suntrap', VEHICLE_MODEL = joaat('suntrap'), VEHICLE_PRICE = 1000},
            {label = 'Toro', VEHICLE_MODEL = joaat('toro'), VEHICLE_PRICE = 1000},
            {label = 'ToroB', VEHICLE_MODEL = joaat('toro2'), VEHICLE_PRICE = 1000},
            {label = 'Tropic', VEHICLE_MODEL = joaat('tropic'), VEHICLE_PRICE = 1000},
            {label = 'TropicB', VEHICLE_MODEL = joaat('tropic2'), VEHICLE_PRICE = 1000},
            {label = 'Longfin', VEHICLE_MODEL = joaat('longfin'), VEHICLE_PRICE = 1000},
       }},
    },
    ['planes'] = {
        {label = locale('helicopters'), dbData = 'plane', values = {
            {label = 'havok', VEHICLE_MODEL = joaat('havok'), VEHICLE_PRICE = 1000}, 
            {label = 'nokota', VEHICLE_MODEL = joaat('nokota'), VEHICLE_PRICE = 1000}, 
        }},
        {label = locale('planes'), dbData = 'plane', values = {
            {label = 'havok', VEHICLE_MODEL = joaat('havok'), VEHICLE_PRICE = 1000}, 
            {label = 'nokota', VEHICLE_MODEL = joaat('nokota'), VEHICLE_PRICE = 1000}, 
        }},
    },

}