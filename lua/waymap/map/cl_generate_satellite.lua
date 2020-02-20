Waymap.Map = Waymap.Map or {}

Waymap.Map.generators[Waymap.Map.MODE.SATELLITE] = function(camera, callback)
	local width, height = 2048, 2048
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
