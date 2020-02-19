--[[
	Shared Waypoint code
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._waypointID = Waymap.Waypoint._waypointID or 0
Waymap.Waypoint._waypoints = Waymap.Waypoint._waypoints or {}

--[[
	Basic waypoint editing functions
--]]

function Waymap.Waypoint.Add(name, description, position, color, icon)
	Waymap.Waypoint._waypointID = Waymap.Waypoint._waypointID + 1
	Waymap.Waypoint._waypoints[Waymap.Waypoint._waypointID] = {
		name = name,
		description = description,
		position = position,
		color = color,
		icon = icon
	}
	
	return Waymap.Waypoint._waypointID
end

function Waymap.Waypoint.Get(waypointID)
	return Waymap.Waypoint._waypoints[waypointID]
end

function Waymap.Waypoint.Remove(waypointID)
	Waymap.Waypoint._waypoints[waypointID] = nil
end

function Waymap.Waypoint.GetAll()
	return Waymap.Waypoint._waypoints
end

function Waymap.Waypoint.RemoveAll()
	Waymap.Waypoint._waypoints = {}
end
