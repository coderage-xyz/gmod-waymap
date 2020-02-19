--[[
	Serverside handling of net messages regarding Waypoints
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._waypoints = Waymap.Waypoint._waypoints or {}

util.AddNetworkString("Waymap.Waypoint.Request")
util.AddNetworkString("Waymap.Waypoint.Send")

--[[
	Basic waypoint editing functions
--]]

function Waymap.Waypoint.Add(name, desc, position, color, icon)
	local index = Waymap.Waypoint._cur
	Waymap.Waypoint._cur = Waymap.Waypoint._cur + 1
	
	local waypoint = {
		name = name,
		desc = desc,
		position = position,
		color = color,
		icon = icon
	}
	
	Waymap.Waypoint._waypoints[index] = waypoint
	return index
end

--[[
	Net handling
--]]

net.Receive("Waymap.Waypoint.Request", function(ln, ply)
	local id = net.ReadFloat()
	
	net.Start("Waymap.Waypoint.Send")
		net.WriteFloat(id)
		net.WriteTable(Waymap.Waypoint.GetAll())
	net.Send(ply)
end)
