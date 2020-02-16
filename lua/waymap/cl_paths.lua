--[[
	Path management on client
--]]

--[[
	Concommands that I use when debugging:
	lua_run_clients Waymap.RequestPath(here, there)
--]]

Waymap.Path = Waymap.Path or {}

Waymap.Path._paths = Waymap.Path._paths or {}
Waymap.Path._active = Waymap.Path._active or {}

Waymap.Path._arrows = Waymap.Path._arrows or {}

Waymap.Path._texcoord = 8

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
	
	local path = Waymap.Path.Get(pathid)
	if path then
		Waymap.Path.PopulateArrows(path)
		Waymap.Path._texcoord = (0.1 * Waymap.Path.GetTotalLength(path) / #path)
	end
end

function Waymap.Path.GetActive()
	return Waymap.Path._paths[Waymap.Path._active]
end

function Waymap.Path.Get(pathid)
	return Waymap.Path._paths[pathid]
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
	Waymap.Path.SetActive(nil)
	Waymap.Path._paths = {}
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
	
	return newpath
end

function Waymap.Path.SubdivCorners(path) -- path is a table of vectors
	print("[Waymap] Path is " .. #path .. " segments before corner subdivision.")

	local newpath = {}
	for i, vec in pairs(path) do
		local last, next = path[i - 1], path[i + 1]
		
		if not last or not next then
			table.insert(newpath, vec)
		else
			local thirdbefore = ((2 / 3) * vec + (last / 3))
			local thirdafter = ((2 / 3) * vec + (next / 3))

			debugoverlay.Sphere(thirdbefore, 4, 10)
			debugoverlay.Sphere(vec, 4, 10)
			debugoverlay.Sphere(thirdafter, 4, 10)
			
			table.insert(newpath, thirdbefore)
			table.insert(newpath, vec)
			table.insert(newpath, thirdafter)
		end
	end
	
	print("[Waymap] Path is " .. #newpath .. " segments after corner subdivision.")
	
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
	if (r > n) then
		Error("[Waymap] What are you trying to do, cause a stack overflow? In all binomial coefficients you must ensure that r is never greater than n.")
		return nil
	end
	
	return (fact(n) / (fact(n - r) * fact(r)))
end

function Waymap.Path.BezierRecursive(subdiv, args)
	local n = (#args - 1)
	local bpath = {}
	
	for t = 0, 1, (1 / subdiv) do
		local vec = Vector(0, 0, 0)
		for i = 0, n do
			vec = vec + (binomial(n, i) * math.pow((1 - t), (n - i)) * math.pow(t, i) * (args[i + 1]))
		end
		table.insert(bpath, vec)
	end
	
	return bpath
end

function Waymap.Path.BezierPath(path, subdiv)
	subdiv = subdiv or 16
	return Waymap.Path.BezierRecursive(subdiv, path)
end

function Waymap.Path.DeleteArrows()
	for i, arrow in pairs(Waymap.Path._arrows) do
		arrow:Remove()
		Waymap.Path._arrows[i] = nil
	end
end

local arrowmdl = Model("models/waymap/arrow_indent.mdl")

function Waymap.Path.PopulateArrows(path)
	if Waymap.Path._arrows then Waymap.Path.DeleteArrows() end
	for i, node in pairs(path) do
		if not path[i - 1] then continue end
		
		local arrow = ClientsideModel(arrowmdl, RENDERGROUP_OPAQUE)
		arrow:SetPos(node)
		local yaw = (path[i - 1] - node):Angle().yaw
		arrow:SetAngles(Angle(0, yaw, 0))
		arrow:Spawn()
		
		table.insert(Waymap.Path._arrows, arrow)
	end
end
