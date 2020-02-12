--[[
	Drawing our active path
--]]

local arrowmat = Material("waymap/arrow_outline")
--local wpmat = Material( "sprites/sent_ball" )

hook.Add("PostDrawOpaqueRenderables", "Waymap.DrawPath", function()
	local active = Waymap.Path.GetActive()
	
	if not istable(active) then return end
	
	local last
	
	--[[
	for k, node in pairs(active) do
		node = node + Vector(0, 0, 8)
		
		if (k == 1) or (k == #active) then
			cam.Start3D2D(node, Angle(0, 0, 0), 1)
				surface.SetMaterial(wpmat)
				surface.DrawTexturedRect(-16, -16, 32, 32)
			cam.End3D2D()
		end
		
		if (last) then
			render.SetMaterial(arrowmat)
			render.DrawBeam(last, node, 8, 0, last:Distance(node) / 8)
			--print("Path drawn.")
		end

		last = node
	end
	--]]
	
	render.SetMaterial(arrowmat)
	render.StartBeam(#active)
		for i, node in pairs(active) do
			render.AddBeam(node, 8, (CurTime() + i * (#active / 2)), color_white)
		end
	render.EndBeam()
end)
