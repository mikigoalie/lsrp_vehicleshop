--[[ Main ]]--
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

--[[ Misc ]]--
author 'mikigoalie @ LSRP (dsc.gg/lsrpscripts)'
description '[ESX / OX] Simple vehicleshop utilizing OX Library'
version '2.0.0'

--[[ Resource related ]]--
files { 'locales/*.json', '**/modules/*.lua', '**/bridge/*.lua' }
dependencies { 'oxmysql', 'ox_lib' }
provide 'esx_vehicleshop'

shared_scripts { '@ox_lib/init.lua', 'shared/shared.lua', 'shared/config.lua', 'shared/vehiclelist.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/server.lua' }
client_scripts { 'client/client.lua' }