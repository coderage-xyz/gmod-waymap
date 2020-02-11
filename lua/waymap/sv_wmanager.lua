--[[
	Add manager to player metatable
--]]

local PLAYER = FindMetaTable("Player")

function PLAYER:MakeWManager()
	self.WManager = ents.Create("waypoint_manager")
	self.WManager:SetPos(ply:GetPos())
	self.WManager:SetParent(ply)
	self.WManager:Spawn()
	
	return self.WManager
end

function PLAYER:GetWManager()
	local wmanager = self.WManager
	
	if not IsValid(wmanager) then
		wmanager = self:MakeWManager()
	end
	
	return wmanager
end

--[[
	Give players a waypoint manager on spawn
--]]

hook.Add("PlayerSpawn", "Waymap.SpawnWaypointManager", function(ply)
	if not IsValid(ply:GetWManager()) then
		ply:MakeWManager()
		print("Made waypoint manager " .. tostring(ply:GetWManager()))
	else
		print("Player manager is valid, doing nothing.")
	end
end)
