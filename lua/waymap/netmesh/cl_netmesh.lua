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

net.Receive("Waymap.Map.Send", function(ln)
	local callbackid = net.ReadFloat()
	local chunkid = net.ReadFloat()
	local islast = net.ReadBool()
	local chunk = net.ReadString()
	print("[Waymap] Received chunk of " .. (ln / 1000) .. " Kb")
	
	table.insert(chunks, chunkid, chunk)
	
	if islast then
		local tab = {}
		for _, chunk in pairs(chunks) do
			table.insert(tab, chunk)
		end
		
		local data
		for _, str in pairs(tab) do
			data = data or ""
			data = data .. str
		end
		
		local mesh2d = util.JSONToTable(util.Decompress(data))
		print(mesh2d)
		
		callbacks[callbackid](mesh2d)
	end
end)
