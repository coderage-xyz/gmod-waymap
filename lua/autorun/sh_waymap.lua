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

-- Config
Waymap.Include("waymap/sh_config.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/convars/sh_convars.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/convars/cl_convars.lua", Waymap.INSTANCE.CLIENT)

-- Resource
Waymap.Include("waymap/resource/sv_resource.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/resource/sh_precache.lua", Waymap.INSTANCE.SHARED)

-- Camera
Waymap.Include("waymap/camera/sh_camera.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/camera/sv_camera.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/camera/cl_camera.lua", Waymap.INSTANCE.CLIENT)

-- UI
Waymap.Include("waymap/ui/cl_ui.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/ui/cl_icons.lua", Waymap.INSTANCE.CLIENT)

-- Map
Waymap.Include("waymap/map/cl_map.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/map/cl_generate_satellite.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/map/cl_drawmap.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/map/sh_mapmesh.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/map/sv_mapmesh.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/map/cl_mapmesh.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/map/sv_netmesh.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/map/cl_netmesh.lua", Waymap.INSTANCE.CLIENT)

-- Path
Waymap.Include("waymap/path/sv_astar.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/path/sv_drawpath.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/path/cl_paths.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/path/cl_drawpath.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/path/sv_netpath.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/path/cl_netpath.lua", Waymap.INSTANCE.CLIENT)

-- VGUI
Waymap.Include("waymap/vgui/dwaymapcameraeditor.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/vgui/dwaymap.lua", Waymap.INSTANCE.CLIENT)

-- GWEN skin
Waymap.Include("skins/waymap.lua", Waymap.INSTANCE.CLIENT)

-- Debug
Waymap.Include("waymap/debug/sh_debug.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/debug/cl_showicons.lua", Waymap.INSTANCE.CLIENT)
