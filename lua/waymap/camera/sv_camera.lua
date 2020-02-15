Waymap.Camera.location = "DATA"
Waymap.Camera.folders = "waymap/camera"
Waymap.Camera.extension = "json"
Waymap.Camera.loadedCamera = nil

util.AddNetworkString("Waymap.Camera.ServerRequestCamera")
util.AddNetworkString("Waymap.Camera.ServerSaveCamera")
util.AddNetworkString("Waymap.Camera.ClientSendCamera")

--Save camera to file for current map
function Waymap.Camera.Save(camera)
	file.CreateDir(Waymap.Camera.folders)
	
	local f = file.Open(Waymap.Camera.GetFullFilePath(), "w", Waymap.Camera.location)
	f:Write(util.TableToJSON(camera))
	f:Close()
	
	Waymap.Camera.loadedCamera = camera
end

--Load camera from file for current map
function Waymap.Camera.Load()
	local f = file.Open(Waymap.Camera.GetFullFilePath(), "r", Waymap.Camera.location)
	local data = f:Read(f:Size())
	f:Close()
	
	if data then
		return util.JSONToTable(data)
	end
end

--Get the full file path including folders, map name and extension
function Waymap.Camera.GetFullFilePath()
	return Waymap.Camera.folders .. "/" .. game.GetMap() .. "." .. Waymap.Camera.extension
end

--Does the file exist for the current map?
function Waymap.Camera.FileExists()
	return file.Exists(Waymap.Camera.GetFullFilePath(), Waymap.Camera.location)
end

function Waymap.Camera.Get()
	if not Waymap.Camera.loadedCamera then
		if Waymap.Camera.FileExists() then
			Waymap.Camera.loadedCamera = Waymap.Camera.Load()
		else
			local min, max = game.GetWorld():GetModelBounds()
			local maxBound = math.max(min.x - max.x, max.x - min.x, min.y - max.y, max.z - min.z)
			
			Waymap.Camera.loadedCamera = {
				position = Vector(0, 0, maxBound),
				zoom = maxBound,
				rotation = 0
			}
			
			PrintTable(Waymap.Camera.loadedCamera)
		end
	end
	
	return Waymap.Camera.loadedCamera
end

net.Receive("Waymap.Camera.ServerRequestCamera", function(len, ply)
	local callbackID = net.ReadFloat()
	
	if callbackID then
		net.Start("Waymap.Camera.ClientSendCamera")
		net.WriteFloat(callbackID)
		net.WriteTable(Waymap.Camera.Get())
		net.Send(ply)
	end
end)

net.Receive("Waymap.Camera.ServerSaveCamera", function(len, ply)
	local camera = net.ReadTable()
	
	if camera then
		if Waymap.Config.CanEditMapCamera(ply) then
			Waymap.Camera.Save(camera)
			
			ply:SendLua("GAMEMODE:AddNotify(\"Map camera saved!\", NOTIFY_GENERIC, 4)")
		else
			ply:SendLua("GAMEMODE:AddNotify(\"You do not have permission to edit the map camera!\", NOTIFY_ERROR, 4)")
		end
	end
end)
