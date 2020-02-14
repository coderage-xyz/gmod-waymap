--[[
	Drawing our active path
--]]

Waymap._waypointmdls = Waymap._waypointmdls or {}

local arrowmat = Material("waymap/arrow_outline")
--local waypointmat = Material("waymap/waypoint")

local waypointmodel = Model("models/waymap/waypoint.mdl")

local waypointstartcolor = Color(255, 154, 0)
local waypointendcolor = Color(39, 167, 216)

local ptoffset = Vector(0, 0, 20)
local waypointoffset = Vector(0, 0, 40)

hook.Add("Think", "Waymap.MoveWaypointModels", function()
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
	
	render.SetMaterial(arrowmat)
	render.StartBeam(#active)
		for i, node in pairs(active) do
			node = node + ptoffset
			--local texcoord = (0.1 * Waymap.Path.GetTotalLength(active) / #active)
			render.AddBeam(node, 8, (i * Waymap.Path._texcoord), color_white)
		end
	render.EndBeam()
end)
