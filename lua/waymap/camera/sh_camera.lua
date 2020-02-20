Waymap.Camera = Waymap.Camera or {}
Waymap.Camera.loadedCamera = Waymap.Camera.loadedCamera or nil

function Waymap.Camera.WorldToMap(camera, position)
	local size = camera.renderTargetSize
	local factor = size / (camera.zoom * 2)
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
	x = x + size / 2
	y = y + size / 2
	
	--x and y are reversed here but the function should be used like this: local x, y = Waymap.Camera.WorldToMap(...)
	return y, x
end

--TODO: Make this work
--[[function Waymap.Camera.MapToWorld(camera, x, y, viewPortSize)
	local factor = viewPortSize / (camera.zoom * 2)
	local viewPortSizeHalf = viewPortSize / 2
	local position = Vector(x, y, 0)
	
	--Move the view port by half
	--position = position - Vector(viewPortSize / 2, viewPortSize / 2, position.z)
	print(position)
	
	--Rotate position
	--position:Rotate(Angle(0, camera.rotation * 90, 0))
	
	--Translate camera position
	position = position - Vector(camera.position.x / factor, camera.position.y / factor, position.z)
	
	--Translate position
	position = position - Vector(position.y, position.x, position.z)
	
	debugoverlay.Cross(position, 500, 5, Color(255, 0, 0), true)
	print(position)
	return position
end]]
