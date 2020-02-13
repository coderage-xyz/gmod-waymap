--[[
	Drawing our active path
--]]

Waymap._waypointmdls = Waymap._waypointmdls or {}

local arrowmat = Material("waymap/arrow_outline")
--local waypointmat = Material("waymap/waypoint")

local waypointmodel = Model("models/waymap/waypoint.mdl")

local waypointstartcolor = Color(255, 154, 0)
local waypointendcolor = Color(39, 167, 216)

--[[
local waypointsize = {
	min = 16,
	max = 20,
	speed = 3,
	cur = 20
}
--]]

local ptoffset = Vector(0, 0, 20)
local waypointoffset = Vector(0, 0, 40)

hook.Add("Think", "Waymap.DoDrawCalculations", function()
	local curpath = Waymap.Path.GetActive()
	if istable(curpath) then
		if not Waymap._waypointmdls.waypointstart then
			Waymap._waypointmdls.waypointstart = ClientsideModel(waypointmodel, RENDERGROUP_OPAQUE)
			Waymap._waypointmdls.waypointstart:SetColor(waypointstartcolor)
		end
		
		if not Waymap._waypointmdls.waypointend then
			Waymap._waypointmdls.waypointend = ClientsideModel(waypointmodel, RENDERGROUP_OPAQUE)
			Waymap._waypointmdls.waypointend:SetColor(waypointendcolor)
		end
		
		local height = 4 * math.cos(CurTime())
		
		Waymap._waypointmdls.waypointstart:SetPos(curpath[1] + Vector(0, 0, height) + waypointoffset)
		Waymap._waypointmdls.waypointend:SetPos(curpath[#curpath] + Vector(0, 0, height) + waypointoffset)
		
		Waymap._waypointmdls.waypointstart:SetAngles(Angle(0, CurTime() * 16, 0))
		Waymap._waypointmdls.waypointend:SetAngles(Angle(0, CurTime() * 16, 0))
		
		--[[
		waypointsize.cur = math.cos(CurTime() * waypointsize.speed)
		waypointsize.cur = math.Remap(waypointsize.cur, -1, 1, waypointsize.min, waypointsize.max)
		--]]
	else
		if Waymap._waypointmdls.waypointstart then
			Waymap._waypointmdls.waypointstart:Remove()
		end
		
		if Waymap._waypointmdls.waypointend then
			Waymap._waypointmdls.waypointend:Remove()
		end
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
	
	--[[
	render.SetMaterial(waypointmat)
	render.DrawSprite(active[1] + ptoffset, waypointsize.cur, waypointsize.cur * 2, waypointstartcolor)
	--]]
	
	render.SetMaterial(arrowmat)
	render.StartBeam(#active)
		for i, node in pairs(active) do
			node = node + ptoffset
			--local texcoord = (0.1 * Waymap.Path.GetTotalLength(active) / #active)
			render.AddBeam(node, 8, (i * Waymap.Path._texcoord), color_white)
		end
	render.EndBeam()
	
	--[[
	render.SetMaterial(waypointmat)
	render.DrawSprite(active[#active] + ptoffset, waypointsize.cur, waypointsize.cur * 2, waypointendcolor)
	--]]
end)
