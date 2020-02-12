--[[
	Path management on client
--]]

Waymap.Path = Waymap.Path or {}

Waymap.Path._paths = Waymap.Path._paths or {}
Waymap.Path._active = Waymap.Path._active or {}

function Waymap.Path.Add(path) -- path is a table of vectors
	local id = table.Count(Waymap.Path._paths) + 1
	Waymap.Path._paths[id] = path
	return id
end

function Waymap.Path.Remove(id)
	local removed = IsValid(Waymap.Path._paths[id])
	Waymap.Path._paths[id] = nil
	return removed
end

function Waymap.Path.SetActive(pathid)
	Waymap.Path._active = pathid
end

function Waymap.Path.GetActive()
	return Waymap.Path._paths[Waymap.Path._active]
end

function Waymap.Path.RemoveActive()
	local removed = IsValid(Waymap.Path._active)
	Waymap.Path._active = nil
	return removed
end

function Waymap.Path.GetPaths()
	return Waymap.Path._paths
end

function Waymap.Path.ClearPaths()
	Waymap.Path._paths = nil
end

--[[
	Simple utility functions
--]]

function Waymap.Path.GetTotalLength(path) -- path is a table of vectors
	local distance = 0
	
	for i, vec in pairs(path) do
		if (i == 1) then continue end
		local last = path[i - 1]
		distance = distance + last:Distance(vec)
	end
	
	return distance
end

--[[
	Path subdivision and Bézier curve functions
	
	References:
	https://en.wikipedia.org/wiki/Pascal%27s_triangle
	https://en.m.wikipedia.org/wiki/B%C3%A9zier_curve
--]]

function Waymap.Path.Subdiv(path) -- path is a table of vectors
	print("[Waymap] Path is " .. #path .. " segments before subdivision.")
	
	local last
	local newpath = {}
	for i, vec in pairs(path) do
		if not (last) then
			table.insert(newpath, vec)
		else
			local midpoint = (vec + last) / 2
			table.insert(newpath, midpoint)
			table.insert(newpath, vec)
		end
		
		last = vec
	end
	
	print("[Waymap] Path is " .. #newpath .. " segments after subdivision.")
	
	--PrintTable(newpath)
	return newpath
end

local function fact(n) -- The factorial function, notated as n! in the majority of scholarly practice
	if (n == 0) then
		return 1
	else
		return (n * fact(n - 1))
	end
end

local function binomial(n, r) -- See https://en.wikipedia.org/wiki/Pascal%27s_triangle
	--print("[Waymap] Running binomial function with arguments " .. tostring(n) .. ", " .. tostring(r) .. ".")
	
	if (r > n) then
		Error("[Waymap] What are you trying to do, cause a stack overflow? In all binomial coefficients you must ensure that r is never greater than n.")
		return nil
	end
	
	return (fact(n) / (fact(n - r) * fact(r)))
end

--[[
function Waymap.Path.Bezier3(t, v0, v1, v2) -- Waymap.Path.Bezier(number timestep, vector v0, vector v1, vector v2)
	-- Linear interpolation
	local L0 = (1 - t) * v0 + (t * v1)
	local L1 = (1 - t) * v1 + (t * v2)
	-- Quadratic
	--local Q0 = ((1 - t) * (1 - t)) * v0 + (2 * (1 - t) * t * v1) + (t * t * v2)
	local Q0 = (1 - t) * L0 * t + t * L1 * t
	
	return Q0
end

function Waymap.Path.Bezier3Table(seg, v0, v1, v2) -- Waymap.Path.Bezier(number segments, vector v0, vector v1, vector v2)
	local data = {}
	--table.insert(data, v0)
	--debugoverlay.Sphere(Vector(0, 0, data[#data] * 10), 2, 15)
	for i = 0, 1, (1 / seg) do
		table.insert(data, Waymap.Path.Bezier3(i, v0, v1, v2))
	end
	return data
end
--]]

function Waymap.Path.BezierRecursive(subdiv, ...)
	--subdiv = subdiv or 16
	local args = {...}
	local n = (#args - 1)
	local bpath = {}
	
	for t = 0, 1, (1 / subdiv) do
		local vec = Vector(0, 0, 0)
		for i = 0, n do
			vec = vec + (binomial(n, i) * math.pow((1 - t), (n - i)) * math.pow(t, i) * (args[i + 1]))
		end
		table.insert(bpath, vec)
		--print("[Waymap] Made point " .. tostring(vec) .. " @ " .. #bpath .. ", t = " .. tostring(t))
	end
	
	return bpath
end

function Waymap.Path.BezierPath(path, subdiv)
	subdiv = subdiv or 16
	
	--[[
	local bpath = {}
	table.insert(bpath, path[1])
	
	for i = 3, #path, 3 do
		if not path[i - 1] or not path[i - 2] then continue end
		print("[Waymap] Bézier curving point " .. i .. " on path.")
		local startpoint = path[i - 2]
		local control = path[i - 1]
		local endpoint = path[i]
		
		--table.insert(bpath, startpoint)
		
		for i2 = 1, subdiv do
			local step = (i2 / subdiv)
			local seg = Waymap.Path.Bezier(step, startpoint, control, endpoint)
			print("[Waymap] Made point " .. tostring(seg) .. " @ " .. i .. ".")
			print("[Waymap] Curved point " .. i2 .. ", saving to table.")
			table.insert(bpath, seg)
			
			debugoverlay.Sphere(seg, 8, 15)
			if bpath[#bpath - 1] then
				debugoverlay.Line(seg, bpath[#bpath - 1], 15)
			end
		end
		
		table.insert(bpath, endpoint)
	end
	--]]
	
	return Waymap.Path.BezierRecursive(subdiv, unpack(path))
end
