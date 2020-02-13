--[[
	Drawing our active path
--]]

local arrowmat = Material("waymap/arrow_outline")
local waypointmat = Material("waymap/waypoint")

local waypointstartcolor = Color(255, 154, 0)
local waypointendcolor = Color(39, 167, 216)

local waypointsize = {
	min = 16,
	max = 20,
	speed = 3,
	cur = 20
}

local ptoffset = Vector(0, 0, 16)

hook.Add("Think", "Waymap.DoDrawCalculations", function()
	if istable(Waymap.Path.GetActive()) then
		waypointsize.cur = math.cos(CurTime() * waypointsize.speed)
		waypointsize.cur = math.Remap(waypointsize.cur, -1, 1, waypointsize.min, waypointsize.max)
	end
end)

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
	
	render.SetMaterial(waypointmat)
	render.DrawSprite(active[1] + ptoffset, waypointsize.cur, waypointsize.cur * 2, waypointstartcolor)
	
	--local last
	render.SetMaterial(arrowmat)
	render.StartBeam(#active)
		for i, node in pairs(active) do
			node = node + ptoffset
			--local texcoord = (0.1 * Waymap.Path.GetTotalLength(active) / #active)
			render.AddBeam(node, 8, (i * Waymap.Path._texcoord), color_white)
			--last = node
		end
	render.EndBeam()
	
	render.SetMaterial(waypointmat)
	render.DrawSprite(active[#active] + ptoffset, waypointsize.cur, waypointsize.cur * 2, waypointendcolor)
end)
