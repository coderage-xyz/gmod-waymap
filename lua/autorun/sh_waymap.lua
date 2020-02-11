AddCSLuaFile()

Waymap = Waymap or {}

Waymap.INSTANCE = {}
Waymap.INSTANCE.SHARED = 1
Waymap.INSTANCE.SERVER = 2
Waymap.INSTANCE.CLIENT = 3

--Easier way to include files
function Waymap.Include(path, instance)
	if SERVER then
		if instance == Waymap.INSTANCE.SHARED or instance == Waymap.INSTANCE.CLIENT then
			AddCSLuaFile(path)
		end

		if instance == Waymap.INSTANCE.SHARED or instance == Waymap.INSTANCE.SERVER then
			include(path)
		end
	end

	if CLIENT and (instance == Waymap.INSTANCE.SHARED or instance == Waymap.INSTANCE.CLIENT) then
		include(path)
	end
end

Waymap.Include("Waymap/sh_config.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("Waymap/sv_wmanager.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("Waymap/cl_image.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("Waymap/cl_ui.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("Waymap/vgui/dwaymap.lua", Waymap.INSTANCE.CLIENT)
