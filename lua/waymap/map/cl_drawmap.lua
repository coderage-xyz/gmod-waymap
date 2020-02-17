--[[
	Functions for drawing the satellite map
--]]

function Waymap.Map.Draw(mapmat, x, y, sizex, sizey)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(mapmat)
	surface.DrawTexturedRect(x, y, sizex, sizey)
end
