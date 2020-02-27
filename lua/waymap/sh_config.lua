
Waymap.Config = {
	Title = "Waymap",
	ConVarPrefix = "waymap_",
	
	----Visual----
	
	--Map stuff--
	WaypointSize = 64,
	CompassGap = 128,
	CompassSize = 128,
	PlayerIndicatorSize = 64,
	NodeSize = 32,
	MapTextureSize = 2048,
	
	----Permissions----
	
	--Who can edit the map camera?
	--Possible values: "none", "everyone", "admin" or "superadmin"
	EditMapCameraPermission = "superadmin",
	

	
	----Advanced----
	
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
