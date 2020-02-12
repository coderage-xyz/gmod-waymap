--[[
	Add network strings
--]]

util.AddNetworkString("Waymap.RequestPath")
util.AddNetworkString("Waymap.SendPath")

net.Receive("Waymap.RequestPath", function(ln, ply)
	local id = net.ReadFloat()
	local startpos = net.ReadVector()
	local endpos = net.ReadVector()
	
	local path = Waymap.AstarVector(startpos, endpos)
	
	if not istable(path) then return end
	
	local vecs = Waymap.ConvertAreasToVectors(path)
	
	local json = util.TableToJSON(vecs)
	json = util.Compress(json)
	local jsonlen = #json
	
	net.Start("Waymap.SendPath")
		net.WriteFloat(id)
		net.WriteFloat(jsonlen)
		net.WriteData(json, jsonlen)
	net.Send(ply)
end)
