--[[
	Clientside handling of mesh requests and responses
--]]

Waymap.Map = Waymap.Map or {}
Waymap.Map.meshCallbackID = Waymap.Map.meshCallbackID or 0
Waymap.Map.meshCallbacks = Waymap.Map.meshCallbacks or {}
Waymap.Map.meshChunks = Waymap.Map.meshChunks or {}

--[[
	Net handling
--]]

function Waymap.Map.RequestMesh(callback)
	callback = callback or function(mesh2d)
		Waymap.Map._mesh2d = mesh2d
		Waymap.Map.Shrink()
	end
	
	Waymap.Map.meshCallbackID = Waymap.Map.meshCallbackID + 1
	Waymap.Debug.Print("[Waymap] Saving callback ID: " .. Waymap.Map.meshCallbackID)
	Waymap.Map.meshCallbacks[Waymap.Map.meshCallbackID] = callback
	
	net.Start("Waymap.Map.Request")
		net.WriteFloat(Waymap.Map.meshCallbackID)
	net.SendToServer()
end

net.Receive("Waymap.Map.Send", function(ln)
	local callbackid = net.ReadFloat()
	local islast = net.ReadBool()
	local chunk = net.ReadTable()
	local chunkid = chunk.chunkid
	
	Waymap.Debug.Print("[Waymap] Received chunk of " .. (ln / 1000) .. " Kb")
	
	table.insert(Waymap.Map.meshChunks, chunkid, chunk)
	
	if islast then
		local tab = {}
		for _, chunk in pairs(Waymap.Map.meshChunks) do
			for i, data in pairs(chunk) do
				if not (i == "chunkid") then
					table.insert(tab, data)
				end
			end
		end
		
		Waymap.Debug.Print("[Waymap] Received last chunk. Running callbacks...")
		
		Waymap.Map.meshCallbacks[callbackid](tab)
		Waymap.Map.meshCallbacks[callbackid] = nil
	end
end)
