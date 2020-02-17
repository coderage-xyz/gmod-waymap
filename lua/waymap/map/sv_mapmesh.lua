--[[
	Map functions
--]]

Waymap.Map = Waymap.Map or {}

function Waymap.Map.GetMesh()
	if not Waymap.Map._mesh then
		Waymap.Map._mesh = game.GetWorld():GetPhysicsObject():GetMesh()
	end
	
	return Waymap.Map._mesh
end

function Waymap.Map.GetMesh2D()
	if not Waymap.Map._mesh2d then
		local mesh = Waymap.Map.GetMesh()
		local mesh2d = {}
		local curtri = {}
		
		for _, vert in pairs(mesh) do
			if (#curtri == 3) then
				table.insert(mesh2d, curtri)
				curtri = {}
			end
			
			local newvert = {
				x = vert.pos.x,
				y = vert.pos.y,
				d = vert.pos.z
			}
			
			table.insert(curtri, newvert)
		end
		
		Waymap.Map._mesh2d = mesh2d
	end
	
	return Waymap.Map._mesh2d
end

function Waymap.Map.SplitMeshIntoChunks(mesh)
	local chunks = {}
	local sub = 256
	
	local current = {}
	for i, tri in pairs(mesh) do
		if (#current == sub) or (i == #mesh) then
			table.insert(chunks, current)
			current.chunkid = (#chunks + 1)
			current = {}
		end
		
		table.insert(current, tri)
	end
	
	return chunks
end
