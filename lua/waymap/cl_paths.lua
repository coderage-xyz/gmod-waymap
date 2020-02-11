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
