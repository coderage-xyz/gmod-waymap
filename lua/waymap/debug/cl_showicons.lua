--[[
	Waymap Icons Test
--]]

local iconspath = "waymap/icons/google/"
local iconsearch = "materials/waymap/icons/google/*.png"

local iconparams = "mips"

local icons = {}

local files, directories = file.Find(iconsearch, "GAME")

for _, file in pairs(files) do
	icons[#icons + 1] = Material(iconspath .. file, iconparams)
end

icons[#icons + 1] = Material("waymap/icons/revolver.png", iconparams)

hook.Add("HUDPaint", "DrawGoogleIcons", function()
	if Waymap.ConVars.Debug_ShowIcons() then
		for i, icon in pairs(icons) do
			local x = ((i - 1) % 16) * 150 + 32
			local y = math.floor((i - 1) / 16) * 150 + 32
			
			local color = HSVToColor(i * 15, 1, 1)
			
			surface.SetDrawColor(color.r, color.g, color.b, color.a)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x, y, 128, 128)
		end
	end
end)
