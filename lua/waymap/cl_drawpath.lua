--[[
	Drawing our active path
--]]

local arrowmat = Material("waymap/arrow_outline")

hook.Add("PostDrawOpaqueRenderables", "Waymap.DrawPath", function()
	local active = Waymap.Path.GetActive()
	local last
	
	for _, node in pairs(active) do
		node = node + Vector(0, 0, 8)
		
		if (last) then
			render.SetColorModulation(1, 0, 0)
			render.SetMaterial(arrowmat)
			render.DrawBeam(last, node, 8, 0, last:Distance(node) / 8)
		end

		last = node
	end
end)
