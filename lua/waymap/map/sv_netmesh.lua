--[[
	Serverside handling of mesh requests and responses
--]]

Waymap.Map = Waymap.Map or {}
Waymap.Map.meshCache = Waymap.Map.meshCache or {}

util.AddNetworkString("Waymap.Map.Request")
util.AddNetworkString("Waymap.Map.Send")


--[[
	Useful functions
--]]

local function getStringSize(str)
	return (#str * 8)
end

local function splitString(str)
	local size = math.ceil(#str / 6000)
	local strings = {}
	
	for i = 1, size do
		--Waymap.Debug.Print((i - 1) * size + 1, i * size)
		local splitstr = string.sub((i - 1) * size + 1, i * size)
		table.insert(strings, splitstr)
	end
	
	return strings
end

--[[
	Net handling
--]]

local function SendChunk(ply, callbackid)
	local steamid = ply:SteamID64()
	if not Waymap.Map.meshCache[steamid] then return end
	local islast = (#Waymap.Map.meshCache[steamid] == 1) or false
	
	net.Start("Waymap.Map.Send")
		net.WriteFloat(callbackid)
		net.WriteBool(islast)
		net.WriteTable(Waymap.Map.meshCache[steamid][1])
		Waymap.Debug.Print("[Waymap] Sending chunk number " .. Waymap.Map.meshCache[steamid][1].chunkid)
	net.Send(ply)
	
	table.remove(Waymap.Map.meshCache[steamid], 1)
	
	if islast then Waymap.Map.meshCache[steamid] = nil end
end

net.Receive("Waymap.Map.Request", function(ln, ply)
	if Waymap.Map.meshCache[ply:SteamID64()] then return end
	
	local id = net.ReadFloat()
	
	Waymap.Debug.Print("[Waymap] Getting 2D map mesh...")
	local mesh2d = Waymap.Map.GetMesh2D()
	Waymap.Debug.Print("[Waymap] Got 2D map mesh and stored to variable.")
	
	local strings = splitString(util.TableToJSON(mesh2d))
	
	if not Waymap.Map.meshCache[ply:SteamID64()] then Waymap.Map.meshCache[ply:SteamID64()] = {} end
	local chunks = Waymap.Map.SplitMeshIntoChunks(mesh2d)
	
	for _, chunk in pairs(chunks) do
		table.insert(Waymap.Map.meshCache[ply:SteamID64()], chunk)
	end
	
	Waymap.Debug.Print("[Waymap] Total chunks: " .. #Waymap.Map.meshCache[ply:SteamID64()])
	
	timer.Create("Waymap.Map.Send_" .. ply:SteamID64(), 0.1, #strings, function()
		SendChunk(ply, id)
	end)
end)
