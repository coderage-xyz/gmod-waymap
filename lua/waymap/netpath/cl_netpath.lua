--[[
	Net functions
--]]

--[[
	Concommands that I use when debugging:
	lua_run_clients Waymap.RequestPath(here, there, function(path) Waymap.Path.SetActive(Waymap.Path.Add(path)) end)
--]]

local callbacks = {}

function Waymap.RequestPath(startpos, endpos, callback)
	callback = callback or function(path)
		local id = Waymap.Path.Add(path)
		Waymap.Path.SetActive(id)
	end
	
	--print(callback)
	
	--local id = util.CRC(tostring(startpos) .. tostring(endpos))
	local id = table.Count(callbacks) + 1
	print("[Waymap] Saving callback ID: " .. id)
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
	local subdivcnt, subdivrem = math.modf(distance / 2048)
	
	for i = 1, subdivcnt do
		pathvecs = Waymap.Path.Subdiv(pathvecs) -- Cut the path into smaller pieces by finding midpoints
	end
	
	print("[Waymap] Received path of " .. (ln / 1000) .. " Kb, a total distance of " .. distance .. ".")
	print("[Waymap] Starting Bézier interpolation...")
	pathvecs = Waymap.Path.BezierPath(pathvecs, distance / 64) -- Smooth out jagged edges via recursive parametric Bezier curves
	print("[Waymap] Finished Bézier parametric curve interpolation with " .. #pathvecs .. " segments.")
	print("[Waymap] Running callbacks...")
	callbacks[id](pathvecs) -- Run our callback
	print("[Waymap] Callback has been run, voiding callback.")
	callbacks[id] = nil -- Delete it from our registry
end)
