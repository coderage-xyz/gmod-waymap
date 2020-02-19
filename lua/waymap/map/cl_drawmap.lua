--[[
	Functions for drawing the satellite map
--]]

Waymap.Map = Waymap.Map or {}

Waymap.Map.waypointMat = Material("waymap/waypoint")

Waymap.Map.waypointSize = {
	x = 64,
	y = 128
}

function Waymap.Map.DrawWaypoints(x, y, waypoints, camera, viewPortSize)
	for _, waypoint in pairs(waypoints) do
		local waypointX, waypointY = Waymap.Camera.WorldToMap(camera, waypoint.position, viewPortSize)
		waypointX = waypointX - Waymap.Map.waypointSize.x / 2
		waypointY = waypointY - Waymap.Map.waypointSize.y
		
		Waymap.UI.DrawWaypoint(
			x + waypointX,
			y + waypointY,
			Waymap.Map.waypointSize.x,
			Waymap.Map.waypointSize.y,
			waypoint.icon,
			waypoint.color
		)
	end
end

function Waymap.Map.Draw(camera, material, x, y, viewPortSize)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x, y, viewPortSize, viewPortSize)
	
	local playerX, playerY = Waymap.Camera.WorldToMap(camera, LocalPlayer():GetPos(), viewPortSize)
	surface.DrawCircle(x + playerX, y + playerY, 10, Color(255, 0, 0))
	
	Waymap.Map.DrawWaypoints(x, y, Waymap.Waypoint.GetAll(), camera, viewPortSize)
	Waymap.Map.DrawWaypoints(x, y, Waymap.Waypoint.GetAllLocal(), camera, viewPortSize)
end
