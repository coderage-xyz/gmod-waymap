--[[
	Clientside drawing of map mesh
--]]

local scale = 8192
local mapsize = 1024

function Waymap.Map.GetMesh()
	return Waymap.Map._mesh2d
end

function Waymap.Map.Shrink()
	for i, part in pairs(Waymap.Map.GetMesh()) do
		for _, vert in pairs(part) do
			vert.x = vert.x / scale
			vert.y = vert.y / scale
		end
		
		--[[
		if math.abs(part[3].x - part[1].x) > 0.3 or math.abs(part[3].y - part[1].y) > 0.3 then
			Waymap.Map._mesh2d[i] = nil
		end
		--]]
	end
end

function Waymap.Map.GetMinMaxs(mesh2d)
	local min, max
	for _, part in pairs(mesh2d) do
		for _, vert in pairs(part) do
			if not min then
				min = vert.d
			else
				min = math.min(min, vert.d)
			end
			
			if not max then
				max = vert.d
			else
				max = math.max(max, vert.d)
			end
		end
	end
	
	return min, max
end

function Waymap.Map.Make(mesh2d)
	mesh2d = mesh2d or Waymap.Map.GetMesh()
	
	local rt = GetRenderTarget("waymap_rt_meshmap", mapsize, mapsize)

	render.PushRenderTarget(rt)
		render.OverrideAlphaWriteEnable(true, true)

		render.ClearDepth()
		render.Clear(0, 0, 0, 0)
		
		local boundbot, boundtop = game.GetWorld():GetModelBounds()
		local min, max = Waymap.Map.GetMinMaxs(mesh2d)
		
		if mesh2d then
			for _, part in pairs(mesh2d) do
				local l_avg = (part[1].d + part[2].d + part[3].d) / 3
				local l = math.Remap(l_avg, min, max, 0, 255)
				surface.SetDrawColor(l, l, l, 255)
				draw.NoTexture()
				surface.DrawPoly(part)
			end
		end
		
		render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget()
	
	local mapmat = CreateMaterial("waymap_map_meshmap", "UnlitGeneric", {
		["$basetexture"] = rt:GetName(),
		["$translucent"] = 1,
		["$vertexcolor"] = 1
	})
	
	return mapmat
end

--[[
if not Waymap.Map.GetMesh() then
	Waymap.Map.RequestMesh()
end

map = Waymap.Map.Make(Waymap.Map.GetMesh())

hook.Add("HUDPaint", "TestingDrawMap", function()
	if map then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(map)
		surface.DrawTexturedRect(0, 0, 1024, 1024)
	end
end)
--]]
