--[[
	Clientside handling of net messages regarding Waypoints
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._waypoints = Waymap.Waypoint._waypoints or {}
Waymap.Waypoint._local = Waymap.Waypoint._local or {}

Waymap.Waypoint._callbacks = Waymap.Waypoint._callbacks or {}

--[[
	Waypoint editing functions
--]]

function Waymap.Waypoint.AddLocal(name, desc, position, color, icon)
	local index = Waymap.Waypoint._cur
	Waymap.Waypoint._cur = Waymap.Waypoint._cur + 1
	
	local waypoint = {
		name = name,
		desc = desc,
		position = position,
		color = color,
		icon = icon
	}
	
	Waymap.Waypoint._local[index] = waypoint
	return index
end

function Waymap.Waypoint.GetLocal(index)
	return Waymap.Waypoint._local[index]
end

function Waymap.Waypoint.GetAllLocal()
	return Waymap.Waypoint._local
end

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
