--[[
	Debug printing functions
--]]

Waymap.Debug = Waymap.Debug or {}

function Waymap.Debug.Print(...)
	if not Waymap.ConVars.Debug() then return end
	print(...)
end
