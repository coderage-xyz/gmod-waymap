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

function Waymap.Path.Add(path) -- path is a table of vectors
	local pathID = #Waymap.Path._paths + 1
	Waymap.Path._paths[pathID] = path
	
	Waymap.Path.PopulateArrows(pathID)
	
	return pathID
end

function Waymap.Path.Remove(pathID)
	local removed = IsValid(Waymap.Path._paths[pathID])
	Waymap.Path._paths[pathID] = nil
	
	Waymap.Path.DeleteArrows(pathID)
	
	if Waymap.Path.waypointModels[pathID]  then
		SafeRemoveEntity(Waymap.Path.waypointModels[pathID].waypointstart)
		SafeRemoveEntity(Waymap.Path.waypointModels[pathID].waypointend)
	end
	
	return removed
end

function Waymap.Path.Get(pathid)
	return Waymap.Path._paths[pathid]
end

function Waymap.Path.GetPaths()
	return Waymap.Path._paths
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
				filter = player.GetAll()
			}
			
			local arrow = ClientsideModel(arrowmdl, RENDERGROUP_OPAQUE)
			arrow:SetPos(tr.HitPos)
			local angle = tr.HitNormal:Angle()
			angle:RotateAroundAxis(angle:Right(), -90)
			local rotation = (path[nodeIndex - 1] - node):Angle().y - angle.y
			angle:RotateAroundAxis(angle:Up(), rotation)
			arrow:SetAngles(angle)
			arrow:Spawn()
			
			Waymap.Path._arrows[pathID][#Waymap.Path._arrows[pathID] + 1] = arrow
		end
	end
end
