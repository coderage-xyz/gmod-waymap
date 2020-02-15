--[[
	Serverside handling of mesh requests and responses
--]]

util.AddNetworkString("Waymap.Map.Request")
util.AddNetworkString("Waymap.Map.Send")

--[[
	Useful functions
--]]

local function getStringSize(str)
	return (#str * 8)
end

local function splitString(str)
	local size = math.ceil(#str / 4096)
	print(size)
end

--[[
	Net handling
--]]

net.Receive("Waymap.Map.Request", function(ln, ply)
	local id = net.ReadFloat()
	
	print("[Waymap] Getting 2D map mesh...")
	local mesh2d = Waymap.Map.GetMesh2D()
	print("[Waymap] Got 2D map mesh and stored to variable.")
	
	splitString(util.Compress(util.TableToJSON(mesh2d)))
end)
