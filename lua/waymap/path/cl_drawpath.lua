--[[
	Drawing our active path
--]]

Waymap.Path = Waymap.Path or {}
Waymap.Path.waypointModels = Waymap.Path.waypointModels or {}

Waymap.Path.arrowMat = Material("waymap/arrow_outline")
--Waymap.Path.waypointMat = Material("waymap/waypoint")

Waymap.Path.waypointModel = Model("models/waymap/waypoint_alt.mdl")

Waymap.Path.waypointStartColor = Color(255, 154, 0)
Waymap.Path.waypointEndColor = Color(39, 167, 216)

Waymap.Path.ptOffset = Vector(0, 0, 20)
Waymap.Path.waypointOffset = Vector(0, 0, 40)

hook.Add("Think", "Waymap.MoveWaypointModels", function()
	local curpath = Waymap.Path.GetActive()
	if istable(curpath) then
		if not Waymap.Path.waypointModels.waypointstart then
			Waymap.Path.waypointModels.waypointstart = ClientsideModel(Waymap.Path.waypointModel, RENDERGROUP_OPAQUE)
			Waymap.Path.waypointModels.waypointstart:SetColor(Waymap.Path.waypointStartColor)
		end
		
		if not Waymap.Path.waypointModels.waypointend then
			Waymap.Path.waypointModels.waypointend = ClientsideModel(Waymap.Path.waypointModel, RENDERGROUP_OPAQUE)
			Waymap.Path.waypointModels.waypointend:SetColor(Waymap.Path.waypointEndColor)
		end
		
		local height = 4 * math.cos(CurTime())
		
		Waymap.Path.waypointModels.waypointstart:SetPos(curpath[1] + Vector(0, 0, height) + Waymap.Path.waypointOffset)
		Waymap.Path.waypointModels.waypointend:SetPos(curpath[#curpath] + Vector(0, 0, height) + Waymap.Path.waypointOffset)
		
		Waymap.Path.waypointModels.waypointstart:SetAngles(Angle(0, CurTime() * 16, 0))
		Waymap.Path.waypointModels.waypointend:SetAngles(Angle(0, CurTime() * 16, 0))
	else
		if Waymap.Path.waypointModels.waypointstart then
			Waymap.Path.waypointModels.waypointstart:Remove()
		end
		
		if Waymap.Path.waypointModels.waypointend then
			Waymap.Path.waypointModels.waypointend:Remove()
		end
	end
end)

hook.Add("PostDrawOpaqueRenderables", "Waymap.DrawPath", function()
	local active = Waymap.Path.GetActive()
	
	if not istable(active) then return end
	
	render.SetMaterial(Waymap.Path.arrowMat)
	render.StartBeam(#active)
		for i, node in pairs(active) do
			node = node + Waymap.Path.ptOffset
			--local texcoord = (0.1 * Waymap.Path.GetTotalLength(active) / #active)
			render.AddBeam(node, 8, (i * Waymap.Path._texcoord), color_white)
		end
	render.EndBeam()
end)
