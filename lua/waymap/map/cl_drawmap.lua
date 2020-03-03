--[[
	Functions for drawing the satellite map
--]]

Waymap.Map = Waymap.Map or {}

Waymap.Map.waypointMat = Material("waymap/waypoint")
Waymap.Map.playerMat = Material("waymap/player.png", "alphatest smooth")
Waymap.Map.nodeMat = Material("waymap/pin.png", "alphatest smooth")
Waymap.Map.compassMat = Material("waymap/compass.png", "alphatest smooth")

--[[
	Accessory drawing functions
--]]

function Waymap.Map.DrawWaypoints(x, y, waypoints, camera)
	for _, waypoint in pairs(waypoints) do
		local waypointX, waypointY = Waymap.Camera.WorldToMap(camera, waypoint.position)
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

function Waymap.Map.DrawPaths(x, y, camera)
	for pathID, path in pairs(Waymap.Path.GetPaths()) do
		local color = Waymap.Path.GetColor(pathID)
		
		surface.SetDrawColor(color)
		draw.NoTexture()
		
		for i, this in pairs(path) do
			local thisX, thisY = Waymap.Camera.WorldToMap(camera, this)
			local last = path[i - 1]
			
			if last then
				local lastX, lastY = Waymap.Camera.WorldToMap(camera, last)
				local dX, dY = (thisX - lastX), (thisY - lastY)
				local rot = math.deg(-math.atan(dY / dX))
				surface.DrawTexturedRectRotated(x + (thisX + lastX) / 2, y + (thisY + lastY) / 2, math.sqrt(dX * dX + dY * dY) + 1, 4, rot)
			end
		end
		
		local startX, startY = Waymap.Camera.WorldToMap(camera, path[1])
		local endX, endY = Waymap.Camera.WorldToMap(camera, path[#path])
		
		surface.SetMaterial(Waymap.Map.nodeMat)
		surface.DrawTexturedRect(x + startX - (Waymap.Config.NodeSize / 2), y + startY - (Waymap.Config.NodeSize / 2), Waymap.Config.NodeSize, Waymap.Config.NodeSize)
		surface.DrawTexturedRect(x + endX - (Waymap.Config.NodeSize / 2), y + endY - (Waymap.Config.NodeSize / 2), Waymap.Config.NodeSize, Waymap.Config.NodeSize)
	end
end

function Waymap.Map.DrawPlayer(x, y, camera, ply)
	local playerX, playerY = Waymap.Camera.WorldToMap(camera, ply:GetPos())
	local rot = ply:GetAngles().y - (camera.rotation - 1) * 90
	surface.SetDrawColor(team.GetColor(ply:Team()))
	surface.SetMaterial(Waymap.Map.playerMat)
	surface.DrawTexturedRectRotated(x + playerX, y + playerY, Waymap.Config.PlayerIndicatorSize, Waymap.Config.PlayerIndicatorSize, rot)
end

function Waymap.Map.DrawCompass(panel, camera)
	local x, y = panel:GetSize()
	x, y = (Waymap.Config.CompassGap + (Waymap.Config.CompassSize / 2)), (y - (Waymap.Config.CompassSize / 2) - Waymap.Config.CompassGap)
	local rot = -(camera.rotation * 90)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Waymap.Map.compassMat)
	surface.DrawTexturedRectRotated(x, y, Waymap.Config.CompassSize, Waymap.Config.CompassSize, rot)
end

--[[
	Primary map-drawing functions
--]]

function Waymap.Map.Draw(panel, camera, material, x, y)
	-- The map itself, of course
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x, y, camera.renderTargetSize, camera.renderTargetSize)

	-- Paths
	Waymap.Map.DrawPaths(x, y, camera)
	
	-- Player indicator(s)
	Waymap.Map.DrawPlayer(x, y, camera, LocalPlayer())
	
	-- Waypoint(s)
	Waymap.Map.DrawWaypoints(x, y, Waymap.Waypoint.GetAll(), camera)
	Waymap.Map.DrawWaypoints(x, y, Waymap.Waypoint.GetAllLocal(), camera)
	
	-- Compass
	Waymap.Map.DrawCompass(panel, camera)
end
