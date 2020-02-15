--[[
	Map functions
--]]

Waymap.Map = Waymap.Map or {}

function Waymap.Map.GetMesh()
	return game.GetWorld():GetPhysicsObject():GetMesh()
end

function Waymap.Map.ConvertMesh2D(mesh)
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
			depth = vert.pos.z
		}
		
		table.insert(curtri, newvert)
	end
	
	return mesh2d
end
