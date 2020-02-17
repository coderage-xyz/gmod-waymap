--[[
	Functions for drawing the satellite map
--]]

Waymap.Map = Waymap.Map or {}

function Waymap.Map.Draw(mapMat, x, y, sizeX, sizeY)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(mapMat)
	surface.DrawTexturedRect(x, y, sizeX, sizeY)
	
	if Waymap.Camera.loadedCamera then
		local x, y = Waymap.Camera.WorldToMap(Waymap.Camera.loadedCamera, LocalPlayer():GetPos(), sizeX)
		surface.DrawCircle(x, y, 10, Color(255, 0, 0))
	end
end
