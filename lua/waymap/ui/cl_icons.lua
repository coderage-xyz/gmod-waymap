--[[
	Loading and storage of icons
--]]

Waymap.UI = Waymap.UI or {}

Waymap.UI._icons = Waymap.UI._icons or {}
Waymap.UI._mdlicons = Waymap.UI._mdlicons or {}
Waymap.UI.modelExtension = ".mdl"

--[[
	Useful functions
--]]

local iconspath = "materials/waymap/icons/"
local iconparams = "alphatest smooth"

function Waymap.UI.LoadIcons(folder)
	local path = folder and (iconspath .. folder .. "/") or iconspath
	local files, directories = file.Find(path .. "*", "GAME")
	
	for _, file in pairs(files) do
		if string.GetExtensionFromFilename(file) ~= "png" then continue end
		
		local pathAndName = string.sub(path, 11) .. file
		
		Waymap.UI._icons[pathAndName] = Material(pathAndName, iconparams)
	end
	
	for _, directory in pairs(directories) do
		Waymap.UI.LoadIcons(directory)
	end
end

function Waymap.UI.GetAllIcons()
	return Waymap.UI._icons
end

function Waymap.UI.ModelPathToSpawnIcon(path)
	path = string.sub(path, 1, #path - 4)
	path = "spawnicons/" .. path .. ".png"
	
	local mat = Material(path)
	
	return mat
end

function Waymap.UI.GetOutlinedIcon(icon, rep, coeff) -- icon must be an IMaterial!
	rep = rep or 32
	coeff = coeff or 0.05
	
	local icontag = util.CRC(icon:GetName())
	
	if Waymap.UI._mdlicons[icontag] then
		local entry = Waymap.UI._mdlicons[icontag]
		if (entry.rep == rep) and (entry.coeff == coeff) then
			--Waymap.Debug.Print("[Waymap] Outlined icon already exists for this icon, using that instead.")
			return entry.mat
		end
	end
	
	--Waymap.Debug.Print("[Waymap] No existing outlined icon for specified icon, making a new one...")
	
	local rt = GetRenderTargetEx(
		"waymap_iconrt_" .. icontag,
		icon:Width(),
		icon:Height(),
		RT_SIZE_LITERAL,
		MATERIAL_RT_DEPTH_SHARED,
		1,
		CREATERENDERTARGETFLAGS_UNFILTERABLE_OK,
		IMAGE_FORMAT_DEFAULT
	)
	
	render.PushRenderTarget(rt)
	render.OverrideAlphaWriteEnable(true, true)
	
	render.ClearDepth()
	render.Clear(0, 0, 0, 0)
	
	cam.Start2D()
	
	surface.SetMaterial(icon)
	surface.SetDrawColor(0, 0, 0)
	
	local sizex, sizey = icon:Width() * 0.9, icon:Height() * 0.9
	
	for i = 0, (2 * math.pi), (2 * math.pi) / (rep - 1) do
		local x = (ScrW() / 2) - (sizex / 2) + math.cos(i) * (icon:Width() * coeff)
		local y = (ScrH() / 2) - (sizey / 2) + math.sin(i) * (icon:Height() * coeff)
		
		surface.DrawTexturedRect(x, y, sizex, sizey)
	end
	
	local x, y = (ScrW() / 2) - (sizex / 2), (ScrH() / 2) - (sizey / 2)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawTexturedRect(x, y, sizex, sizey)
	
	cam.End2D()
	
	render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget(rt)
	
	local iconmat = CreateMaterial("waymap_modelicon_" .. icontag .. "1", "UnlitGeneric", {
		["$basetexture"] = rt:GetName(),
		["$translucent"] = 1,
		--["$vertexcolor"] = 1
	})
	
	Waymap.UI._mdlicons[icontag] = {
		mat = iconmat,
		rep = rep,
		coeff = coeff
	}
	
	return iconmat
end

--[[
	Making sure we load the icons
--]]

if (#Waymap.UI.GetAllIcons() == 0) then
	Waymap.UI.LoadIcons()
end

--[[
	Drawing waypoints
--]]

local waypointmat = Material("waymap/waypoint.png", "alphatest smooth")

function Waymap.UI.DrawWaypoint(x, y, sizex, sizey, icon, color)
	surface.SetDrawColor(color)
	surface.SetMaterial(waypointmat)
	surface.DrawTexturedRect(x, y, sizex, sizey)
	
	local iconx = x + (sizex / 2) - (sizex / 4)
	local icony = y + (sizex / 4)
	
	--If is model path
	if string.sub(icon, -4) == Waymap.UI.modelExtension then
		surface.SetMaterial(Waymap.UI.GetOutlinedIcon(Waymap.UI.ModelPathToSpawnIcon(icon)))
	else
		surface.SetMaterial(Waymap.UI.GetAllIcons()[icon])
	end
	
	surface.SetDrawColor(color)
	surface.DrawTexturedRect(iconx, icony, sizex / 2, sizex / 2)
end

--[[
hook.Add("HUDPaint", "WaypointShit", function()
	local icons = Waymap.UI.GetAllIcons()
	local icon = icons[math.floor(CurTime()) % #icons]
	local color = HSVToColor(CurTime() * 32, 1, 1)
	Waymap.Debug.Print(math.floor(CurTime()) % #icons + 1)
	Waymap.UI.DrawWaypoint(64, 64, 128, 256, icon, color)
end)
--]]
