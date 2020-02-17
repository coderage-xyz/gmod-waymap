--[[
	Waymap Icons Test
--]]

Waymap.Debug = Waymap.Debug or {}

hook.Add("HUDPaint", "DrawGoogleIcons", function()
	if Waymap.ConVars.Debug_ShowIcons() then
		for i, icon in pairs(Waymap.UI.GetAllIcons()) do
			local x = ((i - 1) % math.floor(ScrW() / 150)) * 150 + 16
			local y = math.floor((i - 1) / math.floor(ScrW() / 150)) * 150 + 16
			
			local color = HSVToColor(i * 15, 1, 1)
			
			surface.SetDrawColor(color.r, color.g, color.b, color.a)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x, y, 128, 128)
		end
	end
end)
