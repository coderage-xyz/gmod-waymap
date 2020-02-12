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

Waymap.Include("waymap/convars/cl_convars.lua", Waymap.INSTANCE.CLIENT)

Waymap.Include("waymap/sh_config.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/sv_wmanager.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/cl_image.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/cl_ui.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/vgui/dwaymap.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/sv_astar.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/sv_drawpath.lua", Waymap.INSTANCE.SERVER)

Waymap.Include("waymap/netpath/sv_netpath.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/netpath/cl_netpath.lua", Waymap.INSTANCE.CLIENT)

Waymap.Include("waymap/cl_paths.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/cl_drawpath.lua", Waymap.INSTANCE.CLIENT)

Waymap.Include("waymap/sv_resource.lua", Waymap.INSTANCE.SERVER)
