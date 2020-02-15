--[[
	Clientside handling of mesh requests and responses
--]]

local callbacks = {}
local chunks = {}

local isreceiving = false

--[[
	Net handling
--]]

function Waymap.Map.RequestMesh(callback)
	if isreceiving then return end
	
	callback = callback or function(mesh2d)
		PrintTable(mesh2d)
	end
	
	local id = table.Count(callbacks) + 1
	print("[Waymap] Saving callback ID: " .. id)
	callbacks[id] = callback
	
	net.Start("Waymap.Map.Request")
		net.WriteFloat(id)
	net.SendToServer()
end
