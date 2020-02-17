--[[
	Net functions
--]]

local callbacks = {}

function Waymap.RequestPath(startpos, endpos, callback)
	callback = callback or function(path)
		local id = Waymap.Path.Add(path)
		Waymap.Path.SetActive(id)
	end
	
	local id = table.Count(callbacks) + 1
	Waymap.Debug.Print("[Waymap] Saving callback ID: " .. id)
	callbacks[id] = callback
	
	net.Start("Waymap.RequestPath")
		net.WriteFloat(id)
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
	
	Waymap.Debug.Print("[Waymap] Received path of " .. (ln / 1000) .. " Kb, a total distance of " .. distance .. ".")
	
	--pathvecs = Waymap.Path.SubdivCorners(pathvecs)
	
	if Waymap.ConVars.Bezier() then
		Waymap.Debug.Print("[Waymap] Starting Bézier interpolation...")
		pathvecs = Waymap.Path.BezierPath(pathvecs, distance / 32) -- Smooth out jagged edges via recursive parametric Bezier curves
		Waymap.Debug.Print("[Waymap] Finished Bézier parametric curve interpolation with " .. #pathvecs .. " segments.")
	end
	
	Waymap.Debug.Print("[Waymap] Running callbacks...")
	callbacks[id](pathvecs) -- Run our callback
	Waymap.Debug.Print("[Waymap] Callback has been run, voiding callback.")
	callbacks[id] = nil -- Delete it from our registry
	
	--Waymap.Path._texcoord = (0.1 * Waymap.Path.GetTotalLength(pathvecs) / #pathvecs)
end)
