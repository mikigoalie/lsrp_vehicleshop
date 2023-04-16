--[[ Main ]]--
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

--[[ Misc ]]--
author 'mikigoalie @ LSRP (dsc.gg/lsrpeu)'
description '[ESX / OX] Simple vehicleshop utilizing OX Library'
version '2.0.0'


--[[ Resource related ]]--
files { 'locales/*.json' }
dependencies { 'oxmysql', 'ox_lib' }
provide 'esx_vehicleshop'

shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua', 'config.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua', 'server/fn.lua' }
client_scripts { 'client/main.lua', 'client/bridge.lua' }