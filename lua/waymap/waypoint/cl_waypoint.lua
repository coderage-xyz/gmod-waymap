--[[
	Clientside handling of net messages regarding Waypoints
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._localWaypointID = Waymap.Waypoint._localWaypointID or 0
Waymap.Waypoint._localWaypoints = Waymap.Waypoint._localWaypoints or {}
Waymap.Waypoint._callbackID = Waymap.Waypoint._callbackID or 0
Waymap.Waypoint._callbacks = Waymap.Waypoint._callbacks or {}

--[[
	Waypoint editing functions
--]]

function Waymap.Waypoint.AddLocal(name, description, position, color, icon)
	Waymap.Waypoint._localWaypointID = Waymap.Waypoint._localWaypointID + 1
	Waymap.Waypoint._localWaypoints[Waymap.Waypoint._localWaypointID] = {
		name = name,
		description = description,
		position = position,
		color = color,
		icon = icon
	}
	
	return Waymap.Waypoint._localWaypointID
end

function Waymap.Waypoint.GetLocal(localWaypointID)
	return Waymap.Waypoint._localWaypoints[localWaypointID]
end

function Waymap.Waypoint.RemoveLocal(localWaypointID)
	Waymap.Waypoint._localWaypoints[localWaypointID] = nil
end

function Waymap.Waypoint.GetAllLocal()
	return Waymap.Waypoint._localWaypoints
end


function Waymap.Waypoint.RemoveAllLocal()
	Waymap.Waypoint._localWaypoints = {}
end


function Waymap.Waypoint.UploadLocal(localWaypointID)
	local localWaypoint = Waymap.Waypoint.GetLocal(localWaypointID)
	
	net.Start("Waymap.Waypoint.ServerAdd")
	net.WriteString(localWaypoint.name)
	net.WriteString(localWaypoint.description)
	net.WriteVector(localWaypoint.position)
	net.WriteColor(localWaypoint.color)
	net.WriteString(localWaypoint.icon)
	net.SendToServer()
	
	Waymap.Waypoint.RemoveLocal(localWaypointID)
end

--[[
	Net handling
--]]

function Waymap.Waypoint.RequestAllFromServer(callback)
	callback = callback or function(waypoints)
		table.Merge(Waymap.Waypoint._waypoints, waypoints)
	end
	
	Waymap.Waypoint._callbackID = Waymap.Waypoint._callbackID + 1
	Waymap.Waypoint._callbacks[Waymap.Waypoint._callbackID] = callback
	
	Waymap.Debug.Print("[Waymap] Saving callback ID: " .. Waymap.Waypoint._callbackID)
	
	net.Start("Waymap.Waypoint.ServerRequestAll")
	net.WriteFloat(Waymap.Waypoint._callbackID)
	net.SendToServer()
end

net.Receive("Waymap.Waypoint.ClientReceive", function(ln)
	Waymap.Debug.Print("[Waymap] Received packet of " .. (ln / 1000) .. " Kb, reading contents...")
	
	local waypointID = net.ReadFloat()
	local name = net.ReadString()
	local description = net.ReadString()
	local position = net.ReadVector()
	local color = net.ReadColor()
	local icon = net.ReadString()
	
	Waymap.Waypoint.Add(name, description, position, color, icon)
end)

net.Receive("Waymap.Waypoint.ClientReceiveAll", function(ln)
	Waymap.Debug.Print("[Waymap] Received packet of " .. (ln / 1000) .. " Kb, reading contents...")
	
	local id = net.ReadFloat()
	local waypoints = net.ReadTable()
	
	Waymap.Debug.Print("[Waymap] Running callback ID: " .. id)
	
	Waymap.Waypoint._callbacks[id](waypoints)
	Waymap.Waypoint._callbacks[id] = nil
end)
