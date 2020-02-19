--[[
	Shared Waypoint code
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._waypoints = Waymap.Waypoint._waypoints or {}

--[[
	Basic waypoint editing functions
--]]

function Waymap.Waypoint.Get(index)
	return Waymap.Waypoint._waypoints[index]
end

function Waymap.Waypoint.GetAll()
	return Waymap.Waypoint._waypoints
end
