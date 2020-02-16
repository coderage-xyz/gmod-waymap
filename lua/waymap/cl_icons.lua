--[[
	Loading and storage of icons
--]]

Waymap.Icons = Waymap.Icons or {}
Waymap.Icons._icons = Waymap.Icons._icons or {}

--[[
	Useful functions
--]]

local iconspath = "materials/waymap/icons/"
local iconparams = "mips"

function Waymap.Icons.Load(folder)
	local path = folder and (iconspath .. folder .. "/") or iconspath
	local files, directories = file.Find(path .. "*", "GAME")
	
	for _, file in pairs(files) do
		if string.GetExtensionFromFilename(file) ~= "png" then continue end
		Waymap.Icons._icons[#Waymap.Icons._icons + 1] = Material(string.sub(path, 11) .. file, iconparams)
	end
	
	for _, directory in pairs(directories) do
		Waymap.Icons.Load(directory)
	end
end

function Waymap.Icons.GetAll()
	return Waymap.Icons._icons
end

--[[
	Making sure we load the icons
--]]

if (#Waymap.Icons.GetAll() == 0) then
	Waymap.Icons.Load()
end

--[[
	Drawing waypoints
--]]

local waypointmat = Material("waymap/waypoint")

function Waymap.Icons.DrawWaypoint(x, y, sizex, sizey, icon, color)
	surface.SetDrawColor(color)
	surface.SetMaterial(waypointmat)
	surface.DrawTexturedRect(x, y, sizex, sizey)
	
	local iconx = x + (sizex / 2) - (sizex / 4)
	local icony = y + (sizex / 3.75)
	
	surface.SetDrawColor(color)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(iconx, icony, sizex / 2, sizex / 2)
end

--[[
hook.Add("HUDPaint", "WaypointShit", function()
	local icons = Waymap.Icons.GetAll()
	local icon = icons[math.floor(CurTime()) % #icons]
	local color = HSVToColor(CurTime() * 32, 1, 1)
	print(math.floor(CurTime()) % #icons + 1)
	Waymap.Icons.DrawWaypoint(64, 64, 128, 256, icon, color)
end)
--]]
