--[[
	Functions for drawing the satellite map
--]]

Waymap.Map = Waymap.Map or {}

Waymap.Map.waypointMat = Material("waymap/waypoint")

function Waymap.Map.DrawWaypoints(x, y, waypoints, camera, viewPortSize)
	for _, waypoint in pairs(waypoints) do
		local waypointX, waypointY = Waymap.Camera.WorldToMap(camera, waypoint.position, viewPortSize)
		waypointX = waypointX - Waymap.Config.WaypointSize / 2
		waypointY = waypointY - Waymap.Config.WaypointSize * 2
		
		Waymap.UI.DrawWaypoint(
			x + waypointX,
			y + waypointY,
			Waymap.Config.WaypointSize,
			Waymap.Config.WaypointSize * 2,
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
