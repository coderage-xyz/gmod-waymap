--[[
	Net functions
--]]

local callbacks = {}

function Waymap.RequestPath(startpos, endpos, callback)
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
	callbacks[id](pathvecs)
	callbacks[id] = nil
end)
