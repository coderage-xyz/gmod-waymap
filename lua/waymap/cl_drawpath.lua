--[[
	Drawing our active path
--]]

local arrowmat = Material("waymap/arrow_outline")
local wpmat = Material( "sprites/sent_ball" )

hook.Add("PostDrawOpaqueRenderables", "Waymap.DrawPath", function()
	local active = Waymap.Path.GetActive()
	
	if not active then return end
	
	local last
	
	for k, node in pairs(active) do
		node = node + Vector(0, 0, 8)
		
		--[[
		if (k == 1) or (k == #active) then
			cam.Start3D2D(node, Angle(0, 0, 0), 1)
				surface.SetMaterial(wpmat)
				surface.DrawTexturedRect(-16, -16, 32, 32)
			cam.End3D2D()
		end
		--]]
		
		if (last) then
			render.SetMaterial(arrowmat)
			render.DrawBeam(last, node, 8, 0, last:Distance(node) / 8)
		end

		last = node
	end
end)
