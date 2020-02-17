--[[
	Functions for drawing the satellite map
--]]

function Waymap.Map.Draw(mapMat, x, y, sizeX, sizeY)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(mapMat)
	surface.DrawTexturedRect(x, y, sizeX, sizeY)
end
