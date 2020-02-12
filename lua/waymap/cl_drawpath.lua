--[[
	Drawing our active path
--]]

local arrowmat = Material("waymap/arrow_outline")
--local wpmat = Material( "sprites/sent_ball" )

hook.Add("PostDrawOpaqueRenderables", "Waymap.DrawPath", function()
	local active = Waymap.Path.GetActive()
	
	if not istable(active) then return end
	
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
	
	--local last
	render.SetMaterial(arrowmat)
	render.StartBeam(#active)
		for i, node in pairs(active) do
			node = node + Vector(0, 0, 16)
			local texcoord = (0.1 * Waymap.Path.GetTotalLength(active) / #active)
			render.AddBeam(node, 8, (i * texcoord), color_white)
			--last = node
		end
	render.EndBeam()
end)
