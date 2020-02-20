--[[
	Serverside handling of net messages regarding Waypoints
--]]

Waymap.Waypoint = Waymap.Waypoint or {}
Waymap.Waypoint._waypoints = Waymap.Waypoint._waypoints or {}

util.AddNetworkString("Waymap.Waypoint.ServerAdd")
util.AddNetworkString("Waymap.Waypoint.ServerRequestAll")
util.AddNetworkString("Waymap.Waypoint.ClientReceive")
util.AddNetworkString("Waymap.Waypoint.ClientReceiveAll")

--[[
	Basic waypoint editing functions
--]]

function Waymap.Waypoint.Broadcast(waypointID)
	local waypoint = Waymap.Waypoint.Get(waypointID)
	
	Waymap.Debug.Print("[Waymap] Transmitting waypoint \"" .. waypoint.name .. "\" to all clients...")
	
	net.Start("Waymap.Waypoint.ClientReceive")
	net.WriteFloat(waypointID)
	net.WriteString(waypoint.name)
	net.WriteString(waypoint.description)
	net.WriteVector(waypoint.position)
	net.WriteColor(waypoint.color)
	net.WriteString(waypoint.icon)
	net.Broadcast()
	
	Waymap.Debug.Print("[Waymap] Finished transmitting waypoint data.")
end

--[[
	Net handling
--]]

net.Receive("Waymap.Waypoint.ServerRequestAll", function(ln, ply)
	local callbackID = net.ReadFloat()
	
	if callbackID then
		net.Start("Waymap.Waypoint.ClientReceiveAll")
		net.WriteFloat(callbackID)
		net.WriteTable(Waymap.Waypoint.GetAll())
		net.Send(ply)
		
		Waymap.Debug.Print("[Waymap] Sent all global icons to player " .. ply:Name .. ".")
	end
end)

net.Receive("Waymap.Waypoint.ServerAdd", function(ln, ply)
	local name = net.ReadString()
	local description = net.ReadString()
	local position = net.ReadVector()
	local color = net.ReadColor()
	local icon = net.ReadString()
	
	if name and description and position and color and icon then
		local waypointID = Waymap.Waypoint.Add(name, description, position, color, icon)
		Waymap.Waypoint.Broadcast(waypointID)
	end
end)
