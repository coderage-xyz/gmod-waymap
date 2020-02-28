--[[
	Path management on client
--]]

--[[
	Concommands that I use when debugging:
	lua_run_clients Waymap.Path.Request(here, there)
--]]

Waymap.Path = Waymap.Path or {}
Waymap.Path._paths = Waymap.Path._paths or {}
Waymap.Path._arrows = Waymap.Path._arrows or {}
Waymap.Path._colors = Waymap.Path._colors or {}

function Waymap.Path.Add(path, color) -- path is a table of vectors
	local pathID = #Waymap.Path._paths + 1
	Waymap.Path._paths[pathID] = path
	
	Waymap.Path.PopulateArrows(pathID)
	Waymap.Path.SetColor(pathID, color or Color(255, 0, 0))
	
	return pathID
end

function Waymap.Path.Remove(pathID)
	local removed = IsValid(Waymap.Path._paths[pathID])
	
	if Waymap.Path.waypointModels[pathID]  then
		SafeRemoveEntity(Waymap.Path.waypointModels[pathID].waypointstart)
		SafeRemoveEntity(Waymap.Path.waypointModels[pathID].waypointend)
	end
	
	Waymap.Path._paths[pathID] = nil
	Waymap.Path.waypointModels[pathID] = nil
	Waymap.Path._colors[pathID] = nil
	Waymap.Path.DeleteArrows(pathID)
	
	return removed
end

function Waymap.Path.Get(pathID)
	return Waymap.Path._paths[pathID]
end

function Waymap.Path.GetPaths()
	return Waymap.Path._paths
end

function Waymap.Path.SetColor(pathID, color)
	Waymap.Path._colors[pathID] = color
	Waymap.Path.UpdateArrowColors(pathID)
end

function Waymap.Path.GetColor(pathID)
	return Waymap.Path._colors[pathID]
end

function Waymap.Path.UpdateArrowColors(pathID)
	for _, arrow in pairs(Waymap.Path._arrows[pathID]) do
		arrow:SetColor(Waymap.Path.GetColor(pathID))
	end
end

function Waymap.Path.ClearPaths()
	for pathID, path in pairs(Waymap.Path._paths) do
		 Waymap.Path.Remove(pathID)
	end
	
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
	Waymap.Debug.Print("[Waymap] Path is " .. #path .. " segments before subdivision.")
	
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
	
	Waymap.Debug.Print("[Waymap] Path is " .. #newpath .. " segments after subdivision.")
	
	return newpath
end

function Waymap.Path.SubdivCorners(path) -- path is a table of vectors
	Waymap.Debug.Print("[Waymap] Path is " .. #path .. " segments before corner subdivision.")

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
	
	Waymap.Debug.Print("[Waymap] Path is " .. #newpath .. " segments after corner subdivision.")
	
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

--[[
	piqey's best attempt at Catmull-Rom splines
	Quote: "It works!"
--]]

-- don't ask me to explain this
local alpha = .5

-- and also don't ask me to explain how alpha factors into this
local function getT(t, p0, p1)
	local a = math.pow((p1.x - p0.x), 2) + math.pow((p1.y - p0.y), 2) + math.pow((p1.z - p0.z), 2)
	local b = math.sqrt(a)
	local c = math.pow(b, alpha)
	
	return (c + t)
end

-- Makes a Catmull-Rom spline between points p0, p1, p2 and p3 with subdivision length seg
function Waymap.Path.CatmullRomSpline(p0, p1, p2, p3, seg)
	seg = seg or 128
	
	local newPoints = {}
	local t0, t1, t2, t3
	
	t0 = 0
	t1 = getT(t0, p0, p1)
	t2 = getT(t1, p1, p2)
	t3 = getT(t2, p2, p3)
	
	for t = t1, t2, (t2 - t1) / seg do
		local A1, A2, A3
		local B1, B2
		local C
		
		A1 = (t1 - t) / (t1 - t0) * p0 + (t - t0) / (t1 - t0) * p1
		A2 = (t2 - t) / (t2 - t1) * p1 + (t - t1) / (t2 - t1) * p2
		A3 = (t3 - t) / (t3 - t2) * p2 + (t - t2) / (t3 - t2) * p3
		
		B1 = (t2 - t) / (t2 - t0) * A1 + (t - t0) / (t2 - t0) * A2
		B2 = (t3 - t) / (t3 - t1) * A2 + (t - t1) / (t3 - t1) * A3
		
		C = (t2 - t) / (t2 - t1) * B1 + (t - t1) / (t2 - t1) * B2
		
		table.insert(newPoints, C)
	end
	
	return newPoints
end

-- Makes a chain of Catmull-Rom splines; ensure that #path >= 4
function Waymap.Path.CatmullRomChain(path, ln)
	local newpath = {}
	ln = ln or 128
	
	for i = 1, (#path - 3) do
		local estDistance = path[i]:Distance(path[i + 1]) + path[i + 1]:Distance(path[i + 2]) + path[i + 2]:Distance(path[i + 3])
		
		local c = Waymap.Path.CatmullRomSpline(
			path[i],
			path[i + 1],
			path[i + 2],
			path[i + 3],
			math.floor(estDistance / ln)
		)
		
		-- not sure if this is the way I should be doing this
		if (i ~= 1) then
			table.remove(c, 1)
		end
		
		table.Add(newpath, c)
	end
	
	return newpath
end

--[[
	Populating arrows 'n stuff
--]]

function Waymap.Path.DeleteArrows(pathID)
	if Waymap.Path._arrows[pathID] then
		for arrowIndex, arrow in pairs(Waymap.Path._arrows[pathID]) do
			SafeRemoveEntity(arrow)
		end
		
		Waymap.Path._arrows[pathID] = nil
	end
end

local arrowmdl = Model("models/waymap/arrow_indent.mdl")

function Waymap.Path.PopulateArrows(pathID)
	local path = Waymap.Path._paths[pathID]
	
	if path then
		if Waymap.Path._arrows[pathID] then
			Waymap.Path.DeleteArrows(pathID)
		end
		
		Waymap.Path._arrows[pathID] = {}
		
		for nodeIndex, node in pairs(path) do
			if not path[nodeIndex - 1] then continue end
			
			local tr = util.TraceLine{
				start = node,
				endpos = node + Vector(0, 0, -1e5),
				collisiongroup = COLLISION_GROUP_DEBRIS
			}
			
			local arrow = ClientsideModel(arrowmdl, RENDERGROUP_OPAQUE)
			arrow:SetPos(tr.HitPos)
			local angle = tr.HitNormal:Angle()
			angle:RotateAroundAxis(angle:Right(), -90)
			local rotation = (path[nodeIndex - 1] - node):Angle().y - angle.y
			angle:RotateAroundAxis(angle:Up(), rotation)
			arrow:SetAngles(angle)
			
			arrow:SetColor(Waymap.Path.GetColor(pathID))
			
			arrow:Spawn()
			
			Waymap.Path._arrows[pathID][#Waymap.Path._arrows[pathID] + 1] = arrow
		end
	end
end
