--[[
	Clientside handling of net messages regarding Waypoints
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._waypoints = Waymap.Waypoint._waypoints or {}

Waymap.Waypoint._callbacks = Waymap.Waypoint._callbacks or {}

--[[
	Net handling
--]]

function Waymap.Waypoint.RequestFromServer(callback)
	callback = callback or function(waypoints)
		table.Merge(Waymap.Waypoint._waypoints, waypoints)
	end
	
	local id = #Waymap.Waypoint._callbacks + 1
	Waymap.Debug.Print("[Waymap] Saving callback ID: " .. id)
	Waymap.Waypoint._callbacks[id] = callback
	
	net.Start("Waymap.Waypoint.Request")
		net.WriteFloat(id)
	net.SendToServer()
end

net.Receive("Waymap.Waypoint.Send", function(ln)
	Waymap.Debug.Print("[Waymap] Received packet of " .. (ln / 1000) .. " Kb, reading contents...")
	local id = net.ReadFloat()
	local waypoints = net.ReadTable()
	Waymap.Debug.Print("[Waymap] Running callback ID: " .. id)
	Waymap.Waypoint._callbacks[id](waypoints)
	Waymap.Waypoint._callbacks[id] = nil
end)
