Waymap.Map = Waymap.Map or {}

Waymap.Map.MODE = {}
Waymap.Map.MODE.SATELLITE = 1
Waymap.Map.MODE.FLAT = 2

Waymap.Map.selectedMode = Waymap.Map.selectedMode or Waymap.Map.MODE[Waymap.ConVars.DefaultMapMode()] or Waymap.Map.MODE.SATELLITE
Waymap.Map.loadedMaps = Waymap.Map.loadedMaps or {}
Waymap.Map.generators = Waymap.Map.generators or {}
Waymap.Map.location = "DATA"
Waymap.Map.folders = "waymap/maps"
Waymap.Map.extension = "png"

function Waymap.Map.GetGenerator(mode)
	return Waymap.Map.generators[mode]
end

function Waymap.Map.Generate(camera, mode, callback)
	local generator = Waymap.Map.GetGenerator(mode)
	
	generator(camera, function(pngData)
		file.CreateDir(Waymap.Map.folders)
		
		local f = file.Open(Waymap.Map.GetFullFilePath(camera, mode), "wb", Waymap.Map.location)
		f:Write(pngData)
		f:Close()
		
		Waymap.Map.Load(camera, mode, function(material)
			if callback then
				callback(material)
			end
		end)
	end)
end

function Waymap.Map.Load(camera, mode, callback)
	if Waymap.Map.Exists(camera, mode) then
		local material = CreateMaterial(Waymap.Map.GetNameFromCamera(camera, mode), "UnlitGeneric", {
			["$basetexture"] = Material("../data/" .. Waymap.Map.GetFullFilePath(camera, mode)):GetName(),
			["$translucent"] = 1
		})
		
		if callback then
			callback(material)
		end
	else
		if callback then
			callback(nil)
		end
	end
end

function Waymap.Map.Exists(camera, mode)
	return file.Exists(Waymap.Map.GetFullFilePath(camera, mode), Waymap.Map.location)
end

function Waymap.Map.Reload()
	Waymap.Map.loadedMaps = {}
end

function Waymap.Map.Get(camera, mode, callback)
	if Waymap.Map.loadedMaps[mode] then
		if callback then
			callback(Waymap.Map.loadedMaps[mode])
		end
	else
		if Waymap.Map.Exists(camera, mode) then
			Waymap.Map.Load(camera, mode, function(material)
				Waymap.Map.loadedMaps[mode] = material
				
				if callback then
					callback(material)
				end
			end)
		else
			Waymap.Map.Generate(camera, mode, function(material)
				Waymap.Map.loadedMaps[mode] = material
				
				if callback then
					callback(material)
				end
			end)
		end
	end
end

function Waymap.Map.GetNameFromCamera(camera, mode)
	return util.CRC(game.GetIPAddress()) .. "_" .. game.GetMap() .. "_" .. mode .. "_" .. camera.creationTime
end

--Get the full file path including folders, name and extension
function Waymap.Map.GetFullFilePath(camera, mode)
	return Waymap.Map.folders .. "/" .. Waymap.Map.GetNameFromCamera(camera, mode) .. "." .. Waymap.Map.extension
end

hook.Add("Waymap.Camera.LoadedCameraUpdated", "Waymap.Map.GenerateFromLoadedCamera", function(camera)
	Waymap.Map.Reload()
	Waymap.Map.Get(camera, Waymap.Map.selectedMode)
end)
