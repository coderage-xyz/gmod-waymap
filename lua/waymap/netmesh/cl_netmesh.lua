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
		Waymap.Map._mesh2d = mesh2d
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
	local islast = net.ReadBool()
	local chunk = net.ReadTable()
	local chunkid = chunk.chunkid
	
	print("[Waymap] Received chunk of " .. (ln / 1000) .. " Kb")
	
	table.insert(chunks, chunkid, chunk)
	
	if islast then
		local tab = {}
		for _, chunk in pairs(chunks) do
			for i, data in pairs(chunk) do
				if not (i == "chunkid") then
					table.insert(tab, data)
				end
			end
		end
		
		print("[Waymap] Received last chunk. Running callbacks...")
		
		callbacks[callbackid](tab)
		callbacks[callbackid] = nil
	end
end)
