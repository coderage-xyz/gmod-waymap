Waymap.Camera = Waymap.Camera or {}
Waymap.Camera.loadedCamera = Waymap.Camera.loadedCamera or nil
Waymap.Camera.callbackID = Waymap.Camera.callbackID or 0
Waymap.Camera.callbacks = Waymap.Camera.callbacks or {}

function Waymap.Camera.RequestFromServer(callback)
	Waymap.Camera.callbackID = Waymap.Camera.callbackID + 1
	Waymap.Camera.callbacks[Waymap.Camera.callbackID] = callback
	
	net.Start("Waymap.Camera.ServerRequestCamera")
	net.WriteFloat(Waymap.Camera.callbackID)
	net.SendToServer()
end

function Waymap.Camera.SaveCameraToServer(camera)
	net.Start("Waymap.Camera.ServerSaveCamera")
	net.WriteTable(camera)
	net.SendToServer()
end

--Get the currently loaded camera
--Can be nil
function Waymap.Camera.GetLoaded()
	return Waymap.Camera.loadedCamera
end

net.Receive("Waymap.Camera.ClientSendCamera", function(ply)
	local callbackID = net.ReadFloat()
	local camera = net.ReadTable()
	
	Waymap.Camera.callbacks[callbackID](camera)
	Waymap.Camera.callbacks[callbackID] = nil
end)

net.Receive("Waymap.Camera.ClientReload", function(ply)
	Waymap.Camera.RequestFromServer(function(camera)
		Waymap.Camera.loadedCamera = camera
		
		hook.Run("Waymap.Camera.LoadedCameraUpdated", camera)
	end)
end)

hook.Add("InitPostEntity", "Waymap.Camera.InitPostEntity", function()
	Waymap.Camera.RequestFromServer(function(camera)
		Waymap.Camera.loadedCamera = camera
		
		hook.Run("Waymap.Camera.LoadedCameraUpdated", camera)
	end)
end)
