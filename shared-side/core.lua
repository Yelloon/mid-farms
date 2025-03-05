-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Server = IsDuplicityVersion()
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRPS = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Core = {}
Tunnel.bindInterface(GetCurrentResourceName(), Core)
_G[(Server) and "Client" or "Server"] = Tunnel.getInterface(GetCurrentResourceName())

if Server then
	-- Adapt your framework aqui
end