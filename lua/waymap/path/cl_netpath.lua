--[[
	Net functions
--]]

Waymap.Path = Waymap.Path or {}
Waymap.Path.pathCallbackID = Waymap.Path.pathCallbackID or 0
Waymap.Path.pathCallbacks = Waymap.Path.pathCallbacks or {}

function Waymap.Path.Request(startpos, endpos, callback)
	callback = callback or function(path)
		Waymap.Path.Add(path)
	end
	
	Waymap.Path.pathCallbackID = Waymap.Path.pathCallbackID + 1
	Waymap.Debug.Print("[Waymap] Saving callback ID: " .. Waymap.Path.pathCallbackID)
	Waymap.Path.pathCallbacks[Waymap.Path.pathCallbackID] = callback
	
	net.Start("Waymap.RequestPath")
		net.WriteFloat(Waymap.Path.pathCallbackID)
		net.WriteVector(startpos)
		net.WriteVector(endpos)
	net.SendToServer()
end

net.Receive("Waymap.SendPath", function(ln)
	local id = net.ReadFloat()
	local jsonlen = net.ReadFloat()
	local json = net.ReadData(jsonlen)
	
	json = util.Decompress(json)
	pathvecs = util.JSONToTable(json)
	
	local distance = Waymap.Path.GetTotalLength(pathvecs)
	
	Waymap.Debug.Print("[Waymap] Received path of " .. (ln / 1000) .. " Kb, a total distance of " .. math.Round(distance, 2) .. ".")
	
	--pathvecs = Waymap.Path.SubdivCorners(pathvecs)
	
	if (Waymap.ConVars.Path_Method() == 1) then
		Waymap.Debug.Print("[Waymap] Starting Bézier interpolation...")
		pathvecs = Waymap.Path.BezierPath(pathvecs, distance / 32) -- Smooth out jagged edges via recursive parametric Bezier curves
		Waymap.Debug.Print("[Waymap] Finished Bézier parametric curve interpolation with " .. #pathvecs .. " segments.")
	elseif (Waymap.ConVars.Path_Method() == 2) and (#pathvecs >= 4) then -- #pathvecs >= 4 is important here
		Waymap.Debug.Print("[Waymap] Starting Catmull-Rom interpolation...")
		pathvecs = Waymap.Path.CatmullRomChain(pathvecs)
		Waymap.Debug.Print("[Waymap] Finished Catmull-Rom interpolation with " .. #pathvecs .. " segments.")
		
		--[[
		for i, this in pairs(pathvecs) do
			local last = pathvecs[i - 1]
			if last then
				debugoverlay.Line(last, this, #pathvecs)
			end
			debugoverlay.Sphere(this, 4, i, HSVToColor(i * 22.5, 1, 1))
		end
		--]]
	end
	
	Waymap.Debug.Print("[Waymap] Running callbacks...")
	Waymap.Path.pathCallbacks[id](pathvecs) -- Run our callback
	Waymap.Debug.Print("[Waymap] Callback has been run, voiding callback.")
	Waymap.Path.pathCallbacks[id] = nil -- Delete it from our registry
	
	--Waymap.Path._texcoord = (0.1 * Waymap.Path.GetTotalLength(pathvecs) / #pathvecs)
end)
