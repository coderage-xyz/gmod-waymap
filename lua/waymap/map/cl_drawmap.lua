--[[
	Functions for drawing the satellite map
--]]

Waymap.Map = Waymap.Map or {}

function Waymap.Map.Draw(camera, material, x, y, viewPortSize)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x, y, viewPortSize, viewPortSize)
	
	local playerX, playerY = Waymap.Camera.WorldToMap(camera, LocalPlayer():GetPos(), viewPortSize)
	surface.DrawCircle(x + playerX, y + playerY, 10, Color(255, 0, 0))
end
