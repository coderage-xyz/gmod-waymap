AddCSLuaFile()

WayMap = WayMap or {}

WayMap.INSTANCE = {}
WayMap.INSTANCE.SHARED = 1
WayMap.INSTANCE.SERVER = 2
WayMap.INSTANCE.CLIENT = 3

--Easier way to include files
function WayMap.Include(path, instance)
	if SERVER then
		if instance == WayMap.INSTANCE.SHARED or instance == WayMap.INSTANCE.CLIENT then
			AddCSLuaFile(path)
		end

		if instance == WayMap.INSTANCE.SHARED or instance == WayMap.INSTANCE.SERVER then
			include(path)
		end
	end

	if CLIENT and (instance == WayMap.INSTANCE.SHARED or instance == WayMap.INSTANCE.CLIENT) then
		include(path)
	end
end

WayMap.Include("waymap/sh_config.lua", WayMap.INSTANCE.SHARED)
WayMap.Include("waymap/sv_wmanager.lua", WayMap.INSTANCE.SERVER)
