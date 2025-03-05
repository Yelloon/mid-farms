fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
	"client-side/*"
}

server_scripts {
	"server-side/*"
}

shared_scripts {
	-- "@vrp/config/Native.lua",
	-- "@vrp/config/Item.lua",
	"@vrp/lib/utils.lua",
	"shared-side/*"
}