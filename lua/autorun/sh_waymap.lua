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

-- Addon config
Waymap.Include("waymap/sh_config.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/convars/sh_convars.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/convars/cl_convars.lua", Waymap.INSTANCE.CLIENT)

-- Content precaching
Waymap.Include("waymap/sh_precache.lua", Waymap.INSTANCE.SHARED)

-- UI
Waymap.Include("waymap/camera/sh_camera.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/camera/sv_camera.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/camera/cl_camera.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/cl_ui.lua", Waymap.INSTANCE.CLIENT)

-- Map
Waymap.Include("waymap/map/cl_map.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/map/cl_generate_satallite.lua", Waymap.INSTANCE.CLIENT)

-- Pathfinding
Waymap.Include("waymap/sv_astar.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/sv_drawpath.lua", Waymap.INSTANCE.SERVER)

-- Derma
Waymap.Include("waymap/vgui/dwaymapcameraeditor.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/vgui/dwaymap.lua", Waymap.INSTANCE.CLIENT)

-- Mesh functions and data
Waymap.Include("waymap/sh_mapmesh.lua", Waymap.INSTANCE.SHARED)
Waymap.Include("waymap/sv_mapmesh.lua", Waymap.INSTANCE.SERVER)

-- Mesh networking
Waymap.Include("waymap/netmesh/sv_netmesh.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/netmesh/cl_netmesh.lua", Waymap.INSTANCE.CLIENT)

-- Path networking
Waymap.Include("waymap/netpath/sv_netpath.lua", Waymap.INSTANCE.SERVER)
Waymap.Include("waymap/netpath/cl_netpath.lua", Waymap.INSTANCE.CLIENT)

-- Paths
Waymap.Include("waymap/cl_paths.lua", Waymap.INSTANCE.CLIENT)
Waymap.Include("waymap/cl_drawpath.lua", Waymap.INSTANCE.CLIENT)

-- Server downloads
Waymap.Include("waymap/sv_resource.lua", Waymap.INSTANCE.SERVER)

-- GWEN skin
Waymap.Include("skins/waymap.lua", Waymap.INSTANCE.CLIENT)

-- Icons
Waymap.Include("waymap/cl_icons.lua", Waymap.INSTANCE.CLIENT)

-- Debug files
Waymap.Include("waymap/debug/cl_showicons.lua", Waymap.INSTANCE.CLIENT)
