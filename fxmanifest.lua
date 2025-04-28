fx_version 'bodacious'
game 'gta5'
-- husky
client_scripts {
	'@vrp/client/Tunnel.lua',
	'@vrp/client/Proxy.lua',
    '@vrp/lib/utils.lua', 
    'client.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    '@vrp/lib/MySQL.lua',
    'server.lua'
}
