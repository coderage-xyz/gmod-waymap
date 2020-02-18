Waymap.Camera = Waymap.Camera or {}
Waymap.Camera.loadedCamera = Waymap.Camera.loadedCamera or nil

function Waymap.Camera.WorldToMap(camera, position, viewPortSize)
	local factor = viewPortSize / (camera.zoom * 2)
	local viewPortSizeHalf = viewPortSize / 2
	local x, y = 0, 0
	
	--Translate position
	x = x - position.x * factor
	y = y - position.y * factor
	
	--Translate camera position
	x = x - camera.position.y * factor
	y = y - camera.position.x * factor
	
	--Rotate position
	local rotatePosition = Vector(x, y, 0)
	rotatePosition:Rotate(Angle(0, -camera.rotation * 90, 0))
	x = rotatePosition.x
	y = rotatePosition.y
	
	--Move the view port by half
	x = x + viewPortSizeHalf
	y = y + viewPortSizeHalf
	
	--x and y are reversed here but the function should be used like this: local x, y = Waymap.Camera.WorldToMap(...)
	return y, x
end
