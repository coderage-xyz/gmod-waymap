Waymap.Camera = Waymap.Camera or {}
Waymap.Camera.loadedCamera = Waymap.Camera.loadedCamera or nil

function Waymap.Camera.WorldToMap(camera, position)
	local factor = camera.renderTargetSize / (camera.zoom * 2)
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
	x = x + camera.renderTargetSize / 2
	y = y + camera.renderTargetSize / 2
	
	--x and y are reversed here but the function should be used like this: local x, y = Waymap.Camera.WorldToMap(...)
	return y, x
end

function Waymap.Camera.MapToWorld(camera, x, y)
	local factor = camera.renderTargetSize / (camera.zoom * 2)
	local x2, y2 = 0, 0
	
	
	
	--Translate camera position
	x2 = x2 - camera.position.x
	y2 = y2 - camera.position.y
	
	
	
	--Rotate position
	local rotatePosition = Vector(x2, y2, 0)
	rotatePosition.x = rotatePosition.x - camera.position.x
	rotatePosition.x = rotatePosition.y - camera.position.y
	rotatePosition:Rotate(Angle(0, -camera.rotation * 90, 0))
	rotatePosition.x = rotatePosition.x + camera.position.x
	rotatePosition.x = rotatePosition.y + camera.position.y
	x2 = rotatePosition.x
	y2 = rotatePosition.y
	
	--Translate position
	x2 = x2 - x / factor
	y2 = y2 - y / factor
	
	--Move the view port by half
	x2 = x2 + (camera.renderTargetSize / 2) / factor
	y2 = y2 + (camera.renderTargetSize / 2) / factor
	
	--[[debugoverlay.Cross(Vector(y2, x2, 0), 500, 1, Color(255, 0, 0), true)
	print(Vector(y2, x2, 0))
	local ply = LocalPlayer()
	local vec1 = Vector(y2, x2, 0)
	local vec2 = ply:GetShootPos()
	ply:SetEyeAngles((vec1 - vec2):Angle())]]
	return Vector(y2, x2, 0)
end
