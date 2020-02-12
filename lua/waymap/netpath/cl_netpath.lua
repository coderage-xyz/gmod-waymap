--[[
	Net functions
--]]

local callbacks = {}

function Waymap.RequestPath(startpos, endpos, callback)
	callback = callback or function(path)
		local id = Waymap.Path.Add(path)
		Waymap.Path.SetActive(id)
	end
	
	print(callback)
	
	--local id = util.CRC(tostring(startpos) .. tostring(endpos))
	local id = table.Count(callbacks) + 1
	print(id)
	callbacks[id] = callback
	
	net.Start("Waymap.RequestPath")
		net.WriteFloat(id)
		net.WriteVector(startpos)
		net.WriteVector(endpos)
	net.SendToServer()
end

net.Receive("Waymap.SendPath", function(ln)
	local id = net.ReadFloat()
	local pathvecs = net.ReadTable()
	pathvecs = Waymap.Path.Subdiv(pathvecs)
	print("[Waymap] Received path of " .. ln .. " bits. Attempting Bézier curve interpolation.")
	pathvecs = Waymap.Path.BezierPath(pathvecs)
	print("[Waymap] Finished Bézier parametric curve interpolation, running callbacks.")
	callbacks[id](pathvecs)
	print("[Waymap] Callback has been run, voiding callback.")
	callbacks[id] = nil
end)
