-- fxmanifest.lua for qb-adminped
-- This manifest declares the metadata and script files needed to change
-- a player's ped and restore their previous outfit. It is designed for
-- servers running the QBCore framework.

fx_version 'cerulean'
game 'gta5'

author 'Driieen'
description 'Changeped.'
version '1.0.0'

-- QBCore shared locale for notifications
shared_script '@qb-core/shared/locale.lua'

-- Client and server logic
client_script 'client.lua'
server_script 'server.lua'