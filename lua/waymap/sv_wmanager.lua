--[[
	Add manager to player metatable
--]]

local PLAYER = FindMetaTable("Player")

function PLAYER:GetWManager()
	local wmanager = self.WManager
	
	if not IsValid(wmanager) then
		self.WManager = ents.Create("waypoint_manager")
		self.WManager:SetPos(ply:GetPos())
		self.WManager:SetParent(ply)
		self.WManager:Spawn()
		
		wmanager = self.WManager
	end
	
	return wmanager
end
