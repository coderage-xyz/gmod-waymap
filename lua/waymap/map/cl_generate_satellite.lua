Waymap.Map = Waymap.Map or {}
--[[
Waymap.Map.generators[Waymap.Map.MODE.SATELLITE] = function(camera, callback)
	local width, height = camera.renderTargetSize, camera.renderTargetSize
	local texture = GetRenderTargetEx("Waymap.Map.GenerateSatellite", width, height, RT_SIZE_LITERAL, MATERIAL_RT_DEPTH_SHARED, 1, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_DEFAULT)
	
	render.PushRenderTarget(texture)
	cam.Start2D()
	render.OverrideAlphaWriteEnable(true, true)
	render.Clear(0, 0, 0, 0)
	
	render.RenderView({
		origin = Vector(-camera.position.y, -camera.position.x, camera.position.z),
		angles = Angle(90, camera.rotation * 90, 0),
		x = 0,
		y = 0,
		w = width,
		h = height,
		drawhud = false,
		drawmonitors = false,
		drawviewmodel = false,
		viewmodelfov = false,
		drawhud = false,
		bloomtone = false,
		dopostprocess = false,
		ortho = {
			left = -camera.zoom,
			right = camera.zoom,
			top = -camera.zoom,
			bottom = camera.zoom
		}
	})
	
	local pngData = render.Capture({
		format = "png",
		quality = 100,
		alpha = true,
		x = 0,
		y = 0,
		w = width,
		h = height
	})
	
	render.OverrideAlphaWriteEnable(false)
	cam.End2D()
	render.PopRenderTarget()
	
	callback(pngData)
end
]]

Waymap.Map.SATELLITE_RENDER_STAGE = {}
Waymap.Map.SATELLITE_RENDER_STAGE.NONE = 1
Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_1 = 2
Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_2 = 3
Waymap.Map.SATELLITE_RENDER_STAGE.RENDER = 4

Waymap.Map.satelliteMaterial = Waymap.Map.satelliteMaterial or nil
Waymap.Map.satelliteRenderStage = Waymap.Map.satelliteRenderStage or Waymap.Map.SATELLITE_RENDER_STAGE.NONE

Waymap.Map.generators[Waymap.Map.MODE.SATELLITE] = function(camera, callback)
	Waymap.Map.satelliteRenderStage = Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_1
	
	--Setup camera view for mask render
	hook.Add("CalcView", "Waymap.Map.SatelliteSetupView", function(ply, origin, angles, fov, zNear, zFar)
		if Waymap.Map.satelliteRenderStage == Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_1 or Waymap.Map.satelliteRenderStage == Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_2 then
			if Waymap.Map.satelliteRenderStage == Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_1 then
				Waymap.Map.satelliteRenderStage = Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_2
			else
				if Waymap.Map.satelliteRenderStage == Waymap.Map.SATELLITE_RENDER_STAGE.CALC_VIEW_2 then
					Waymap.Map.satelliteRenderStage = Waymap.Map.SATELLITE_RENDER_STAGE.RENDER
				end
				
				hook.Remove("Waymap.Map.SatelliteSetupView")
			end
			
			return {
				origin = Vector(-camera.position.y, -camera.position.x, camera.position.z),
				angles = Angle(90, camera.rotation * 90, 0),
				fov = fov,
				znear = zNear,
				zfar = zFar,
				drawviewer = false,
				ortho = {
					left = -camera.zoom,
					right = camera.zoom,
					top = -camera.zoom,
					bottom = camera.zoom
				}
			}
		end
	end)

	--Render map
	hook.Add("PostDrawTranslucentRenderables", "Waymap.Map.SatelliteRender", function(isDrawingDepth, isDrawingSkybox)
		if not isDrawingSkybox and Waymap.Map.satelliteRenderStage == Waymap.Map.SATELLITE_RENDER_STAGE.RENDER then
			local min, max = game.GetWorld():GetModelBounds()
			local width, height =  camera.renderTargetSize,  camera.renderTargetSize
			local renderTarget = GetRenderTargetEx("waymap_map_satellite_rt", width, height, RT_SIZE_LITERAL, MATERIAL_RT_DEPTH_SHARED, 1, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_DEFAULT)
			
			render.OverrideAlphaWriteEnable(true, true)
			
			render.PushRenderTarget(renderTarget)
			render.ClearDepth()
			render.Clear(0, 0, 0, 0)
			render.PopRenderTarget()
			
			render.CopyRenderTargetToTexture(renderTarget)
			
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.ClearStencil()
			
			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilZFailOperation(STENCIL_REPLACE)
			
			local plateEnt = ClientsideModel("models/hunter/plates/plate8x8.mdl", RENDERGROUP_TRANSLUCENT)
			plateEnt:SetPos(Vector(0, 0, min.z))
			
			local matrix = Matrix()
			matrix:SetScale(Vector(100, 100, 1))
			
			plateEnt:EnableMatrix("RenderMultiply", matrix)
			plateEnt:DrawModel()
			
			SafeRemoveEntity(planeEnt)
			
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			
			render.ClearBuffersObeyStencil(255, 0, 255, 255, false);
			
			render.DrawTextureToScreen(renderTarget)
			
			render.SetStencilEnable(false)
			
			render.CopyRenderTargetToTexture(renderTarget)
			
			render.OverrideAlphaWriteEnable(false)
			
			if callback then
				render.PushRenderTarget(renderTarget)
				
				local pngData = render.Capture({
					format = "png",
					quality = 100,
					alpha = true,
					x = 0,
					y = 0,
					w = width,
					h = height
				})
				
				render.PopRenderTarget()
				
				callback(pngData)
			end
			
			Waymap.Map.satelliteRenderStage = Waymap.Map.SATELLITE_RENDER_STAGE.NONE
		end
	end)
	--[[
	hook.Add("HUDPaint", "test", function()
		if Waymap.Map.satelliteMaterial then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Waymap.Map.satelliteMaterial)
			surface.DrawTexturedRect(ScrW() / 2 - 512, 0, 1024, 1024)
		end
	end)
	]]
end
