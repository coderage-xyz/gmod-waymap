--[[
	Loading and storage of icons
--]]

Waymap.UI = Waymap.UI or {}
Waymap.UI._icons = Waymap.UI._icons or {}

--[[
	Useful functions
--]]

local iconspath = "materials/waymap/icons/"
local iconparams = "mips"

function Waymap.UI.LoadIcons(folder)
	local path = folder and (iconspath .. folder .. "/") or iconspath
	local files, directories = file.Find(path .. "*", "GAME")
	
	for _, file in pairs(files) do
		if string.GetExtensionFromFilename(file) ~= "png" then continue end
		Waymap.UI._icons[#Waymap.UI._icons + 1] = Material(string.sub(path, 11) .. file, iconparams)
	end
	
	for _, directory in pairs(directories) do
		Waymap.UI.LoadIcons(directory)
	end
end

function Waymap.UI.GetAllIcons()
	return Waymap.UI._icons
end

--[[
	Making sure we load the icons
--]]

if (#Waymap.UI.GetAllIcons() == 0) then
	Waymap.UI.LoadIcons()
end

--[[
	Drawing waypoints
--]]

local waypointmat = Material("waymap/waypoint")

function Waymap.UI.DrawWaypoint(x, y, sizex, sizey, icon, color)
	surface.SetDrawColor(color)
	surface.SetMaterial(waypointmat)
	surface.DrawTexturedRect(x, y, sizex, sizey)
	
	local iconx = x + (sizex / 2) - (sizex / 4)
	local icony = y + (sizex / 4)
	
	surface.SetDrawColor(color)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(iconx, icony, sizex / 2, sizex / 2)
end

--[[
hook.Add("HUDPaint", "WaypointShit", function()
	local icons = Waymap.UI.GetAllIcons()
	local icon = icons[math.floor(CurTime()) % #icons]
	local color = HSVToColor(CurTime() * 32, 1, 1)
	Waymap.Debug.Print(math.floor(CurTime()) % #icons + 1)
	Waymap.UI.DrawWaypoint(64, 64, 128, 256, icon, color)
end)
--]]
