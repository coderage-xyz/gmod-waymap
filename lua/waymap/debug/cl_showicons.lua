--[[
	Waymap Icons Test
--]]

local iconspath = "materials/waymap/icons/"
local iconparams = "mips"

local icons = {}

--local files, directories = file.Find(iconsearch, "GAME")

local function LoadAllIcons(folder)
	local path = folder and (iconspath .. folder .. "/") or iconspath
	local files, directories = file.Find(path .. "*", "GAME")
	
	for _, file in pairs(files) do
		if string.GetExtensionFromFilename(file) ~= ".png" then continue end
		icons[#icons + 1] = Material(string.sub(path, 11) .. file, iconparams)
	end
	
	for _, directory in pairs(directories) do
		LoadAllIcons(directory)
	end
end

LoadAllIcons()

hook.Add("HUDPaint", "DrawGoogleIcons", function()
	if Waymap.ConVars.Debug_ShowIcons() then
		for i, icon in pairs(icons) do
			local x = ((i - 1) % math.floor(ScrW() / 150)) * 150 + 16
			local y = math.floor((i - 1) / math.floor(ScrW() / 150)) * 150 + 16
			
			local color = HSVToColor(i * 15, 1, 1)
			
			surface.SetDrawColor(color.r, color.g, color.b, color.a)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x, y, 128, 128)
		end
	end
end)
