
Waymap.Config = {
	Title = "Waymap",
	ConVarPrefix = "waymap_",
	
	--[[ Visual ]]--
	
	-- map stuff
	WaypointSize = 64,
	CompassGap = 64,
	CompassSize = 128,
	PlayerIndicatorSize = 64,
	NodeSize = 32,
	MapTextureSize = 2048,
	IconModels = {
		"models/Items/ammocrate_smg1.mdl";
		"models/Items/BoxSRounds.mdl";
		"models/Items/HealthKit.mdl";
		"models/Items/item_item_crate.mdl";
		"models/props_junk/TrafficCone001a.mdl";
		"models/props_interiors/VendingMachineSoda01a.mdl";
		"models/props_vehicles/carparts_wheel01a.mdl";
		"models/props_c17/FurnitureCouch001a.mdl";
		"models/props_junk/watermelon01.mdl";
		"models/Gibs/HGIBS.mdl";
		"models/props_c17/doll01.mdl";
		"models/props_junk/garbage_takeoutcarton001a.mdl";
	},
	
	--[[ Permissions ]]--
	
	--Who can edit the map camera?
	--Possible values: "none", "everyone", "admin" or "superadmin"
	EditMapCameraPermission = "superadmin",
	

	
	--[[ Advanced ]]--
	
	--Can player edit the map camera?
	CanEditMapCamera = function(self, ply)
		if EditMapCameraPermission == "none" then
			return false
		end
		
		if EditMapCameraPermission == "admin" and not ply:IsAdmin() then
			return false
		end
		
		if EditMapCameraPermission == "superadmin" and not ply:IsSuperAdmin() then
			return false
		end
		
		return true
	end,
}
