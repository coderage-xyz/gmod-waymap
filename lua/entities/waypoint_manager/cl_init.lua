include("shared.lua")

local function drawThePath(path, time)
	local prevArea
	for _, area in pairs(path) do
		debugoverlay.Sphere(area:GetCenter(), 8, time or 9, color_white, true)
		if (prevArea) then
			debugoverlay.Line(area:GetCenter(), prevArea:GetCenter(), time or 9, color_white, true)
		end

		area:Draw()
		prevArea = area
	end
end
