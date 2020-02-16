--[[
	Serverside handling of mesh requests and responses
--]]

util.AddNetworkString("Waymap.Map.Request")
util.AddNetworkString("Waymap.Map.Send")

local callbacks = {}
local cache = {}

--[[
	Useful functions
--]]

local function getStringSize(str)
	return (#str * 8)
end

local function splitString(str)
	local size = math.ceil(#str / 4096)
	local strings = {}
	
	for i = 1, size do
		--print((i - 1) * size + 1, i * size)
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
	if not cache[steamid] then return end
	local islast = (#cache[steamid] == 1) or false
	
	net.Start("Waymap.Map.Send")
		net.WriteFloat(callbackid)
		net.WriteBool(islast)
		net.WriteTable(cache[steamid][1])
		print("[Waymap] Sending chunk number " .. cache[steamid][1].chunkid)
	net.Send(ply)
	
	table.remove(cache[steamid], 1)
	
	if islast then cache[steamid] = nil end
end

net.Receive("Waymap.Map.Request", function(ln, ply)
	if cache[ply:SteamID64()] then return end
	
	local id = net.ReadFloat()
	
	print("[Waymap] Getting 2D map mesh...")
	local mesh2d = Waymap.Map.GetMesh2D()
	print("[Waymap] Got 2D map mesh and stored to variable.")
	
	print(util.TableToJSON(mesh2d))
	local strings = splitString(util.TableToJSON(mesh2d))
	
	if not cache[ply:SteamID64()] then cache[ply:SteamID64()] = {} end
	local chunks = Waymap.Map.SplitMeshIntoChunks(mesh2d)
	
	for _, chunk in pairs(chunks) do
		table.insert(cache[ply:SteamID64()], chunk)
	end
	
	print("[Waymap] Total chunks: " .. #cache[ply:SteamID64()])
	
	timer.Create("Waymap.Map.Send_" .. ply:SteamID64(), 0.1, #strings, function()
		SendChunk(ply, id)
	end)
end)
