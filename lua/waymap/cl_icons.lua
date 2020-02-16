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
