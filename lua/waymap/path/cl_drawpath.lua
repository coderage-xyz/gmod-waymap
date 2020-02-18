--[[
	Drawing our active path
--]]

Waymap.Path = Waymap.Path or {}
Waymap.Path.waypointModels = Waymap.Path.waypointModels or {}
Waymap.Path.waypointModel = Model("models/waymap/waypoint_alt.mdl")
--Waymap.Path.waypointMat = Material("waymap/waypoint")
Waymap.Path.waypointStartColor = Color(255, 154, 0)
Waymap.Path.waypointEndColor = Color(39, 167, 216)
Waymap.Path.waypointOffset = Vector(0, 0, 40)

hook.Add("Think", "Waymap.MoveWaypointModels", function()
	for pathID, path in pairs(Waymap.Path._paths) do
		if not Waymap.Path.waypointModels[pathID]  then
			Waymap.Path.waypointModels[pathID] = {}
		end
		
		if not IsValid(Waymap.Path.waypointModels[pathID].waypointstart) then
			Waymap.Path.waypointModels[pathID].waypointstart = ClientsideModel(Waymap.Path.waypointModel, RENDERGROUP_OPAQUE)
			Waymap.Path.waypointModels[pathID].waypointstart:SetColor(Waymap.Path.waypointStartColor)
		end
		
		if not IsValid(Waymap.Path.waypointModels[pathID].waypointend) then
			Waymap.Path.waypointModels[pathID].waypointend = ClientsideModel(Waymap.Path.waypointModel, RENDERGROUP_OPAQUE)
			Waymap.Path.waypointModels[pathID].waypointend:SetColor(Waymap.Path.waypointEndColor)
		end
		
		local height = 4 * math.cos(CurTime())
		
		Waymap.Path.waypointModels[pathID].waypointstart:SetPos(path[1] + Vector(0, 0, height) + Waymap.Path.waypointOffset)
		Waymap.Path.waypointModels[pathID].waypointend:SetPos(path[#path] + Vector(0, 0, height) + Waymap.Path.waypointOffset)
		
		Waymap.Path.waypointModels[pathID].waypointstart:SetAngles(Angle(0, CurTime() * 16, 0))
		Waymap.Path.waypointModels[pathID].waypointend:SetAngles(Angle(0, CurTime() * 16, 0))
	end
end)
