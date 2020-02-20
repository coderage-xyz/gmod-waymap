--[[
	Functions for drawing the satellite map
--]]

Waymap.Map = Waymap.Map or {}

Waymap.Map.waypointMat = Material("waymap/waypoint")
Waymap.Map.playerMat = Material("waymap/player")

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

function Waymap.Map.DrawPaths(x, y, camera, viewPortSize)
	for pathID, path in pairs(Waymap.Path.GetPaths()) do
		local color = Waymap.Path.GetColor(pathID)
		
		surface.SetDrawColor(color)
		draw.NoTexture()
		
		for i, this in pairs(path) do
			local last = path[i - 1]
			if not last then continue end
			local lastX, lastY = Waymap.Camera.WorldToMap(camera, last, viewPortSize)
			local thisX, thisY = Waymap.Camera.WorldToMap(camera, this, viewPortSize)
			
			--surface.DrawCircle(x + lastX, y + lastY, 2, color)
			
			local dX, dY = (thisX - lastX), (thisY - lastY)
			local rot = math.deg(-math.atan(dY / dX))
			surface.DrawTexturedRectRotated(x + (thisX + lastX) / 2, y + (thisY + lastY) / 2, math.sqrt(dX * dX + dY * dY) + 1, 4, rot)
		end
	end
end

function Waymap.Map.Draw(camera, material, x, y, viewPortSize)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x, y, viewPortSize, viewPortSize)
	
	local playerX, playerY = Waymap.Camera.WorldToMap(camera, LocalPlayer():GetPos(), viewPortSize)
	local rot = LocalPlayer():GetAngles().y - (camera.rotation - 1) * 90
	surface.SetDrawColor(team.GetColor(LocalPlayer():Team()))
	surface.SetMaterial(Waymap.Map.playerMat)
	surface.DrawTexturedRectRotated(x + playerX, y + playerY, Waymap.Config.WaypointSize * 2, Waymap.Config.WaypointSize, rot)
	
	Waymap.Map.DrawPaths(x, y, camera, viewPortSize)
	
	Waymap.Map.DrawWaypoints(x, y, Waymap.Waypoint.GetAll(), camera, viewPortSize)
	Waymap.Map.DrawWaypoints(x, y, Waymap.Waypoint.GetAllLocal(), camera, viewPortSize)
end
