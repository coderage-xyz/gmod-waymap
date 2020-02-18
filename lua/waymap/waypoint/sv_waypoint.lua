--[[
	Serverside handling of net messages regarding Waypoints
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._waypoints = Waymap.Waypoint._waypoints or {}

util.AddNetworkString("Waymap.Waypoint.Request")
util.AddNetworkString("Waymap.Waypoint.Send")

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
