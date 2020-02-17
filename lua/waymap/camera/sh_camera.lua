Waymap.Camera = Waymap.Camera or {}
Waymap.Camera.loadedCamera = Waymap.Camera.loadedCamera or nil

function Waymap.Camera.WorldToMap(camera, position, viewPortSize)
	local factor = viewPortSize / (camera.zoom * 2)
	local x, y = 0, 0
	
	--Translate camera position
	x = x - camera.position.y * factor
	y = y - camera.position.x * factor
	
	--Translate position
	x = x - position.x * factor
	y = y - position.y * factor
	
	--Move the view port by half
	x = x + viewPortSize / 2
	y = y + viewPortSize / 2
	
	--x and y are reversed here but the function should be used like this: local x, y = Waymap.Camera.WorldToMap(...)
	return y, x
end
