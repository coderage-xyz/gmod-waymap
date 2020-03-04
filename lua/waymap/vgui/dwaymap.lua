local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	self.requestedMaterial = false
	self.mapMaterial = nil
	
	--[[
		mapViewPanel
	--]]
	
	self.mapViewPanel = vgui.Create("DPanel", self)
	self.mapViewPanel.viewPositionX, self.mapViewPanel.viewPositionY = 0, 0
	self.mapViewPanel.zoom = 0
	self.mapViewPanel.isMovingView = false
	self.mapViewPanel.pressedCursorPositionX, self.mapViewPanel.pressedCursorPositionY = 0, 0
	self.mapViewPanel.pressedViewPositionX, self.mapViewPanel.pressedViewPositionY = 0, 0
	self.mapViewPanel.camera = {}
	self.mapViewPanel.GetModifiedCamera = function(panel, camera)
		panel.camera.position = camera.position
		panel.camera.zoom = camera.zoom
		panel.camera.rotation = camera.rotation
		panel.camera.renderTargetSize = camera.renderTargetSize + panel.zoom
		panel.camera.creationTime = camera.creationTime
		
		return panel.camera
	end
	self.mapViewPanel.Paint = function(panel, width, height)
		local camera = Waymap.Camera.GetLoaded()
		
		if camera and self.mapMaterial then
			Waymap.Camera.MapToWorld(panel:GetModifiedCamera(camera), panel.pressedCursorPositionX - panel.viewPositionX, panel.pressedCursorPositionY - panel.viewPositionY)
			Waymap.Map.Draw(panel, panel:GetModifiedCamera(camera), self.mapMaterial, panel.viewPositionX, panel.viewPositionY)
		end
	end
	self.mapViewPanel.OnMousePressed = function(panel, keyCode)
		if keyCode == MOUSE_LEFT then
			panel.pressedCursorPositionX, panel.pressedCursorPositionY = self:LocalCursorPos()
			panel.pressedViewPositionX, panel.pressedViewPositionY = panel.viewPositionX, panel.viewPositionY
			panel.isMovingView = true
		end
	end
	self.mapViewPanel.OnMouseWheeled = function(panel, scrollDelta)
		local camera = Waymap.Camera.GetLoaded()
		
		if camera then
			local zoomAdd = 0
			
			if scrollDelta > 0 then
				zoomAdd = camera.renderTargetSize / 10
			elseif scrollDelta < 0 then
				zoomAdd = -camera.renderTargetSize / 10
			end
			
			local cursorX, cursorY = self:LocalCursorPos()
			
			panel.viewPositionX = panel.viewPositionX - (cursorX / panel:GetWide() * ((camera.renderTargetSize + panel.zoom + zoomAdd) - (camera.renderTargetSize + panel.zoom)))
			panel.viewPositionY = panel.viewPositionY - (cursorY / panel:GetTall() * ((camera.renderTargetSize + panel.zoom + zoomAdd) - (camera.renderTargetSize + panel.zoom)))
			panel.zoom = panel.zoom + zoomAdd
		end
	end
	self.mapViewPanel.Think = function(panel)
		if panel.isMovingView then
			if input.IsMouseDown(MOUSE_LEFT) then
				local cursorX, cursorY = self:LocalCursorPos()
				
				panel.viewPositionX = panel.pressedViewPositionX + (cursorX - panel.pressedCursorPositionX)
				panel.viewPositionY = panel.pressedViewPositionY + (cursorY - panel.pressedCursorPositionY)
			else
				panel.isMovingView = false
			end
		end
	end
	
	--[[
		waypointList
	--]]
	
	self.waypointList = vgui.Create("DScrollPanel", self)
	self:UpdateWaypoints()
end

function PANEL:AddWaypoint(key, waypoint, doClick)
	local button = self.waypointList:Add("DButton")
	button:SetText(waypoint.name)
	button:SetTextColor(waypoint.color)
	button:SetFont("DermaLarge")
	button:Dock(TOP)
	local parentWidth, parentHeight = self.waypointList:GetSize()
	button:SetHeight(parentHeight * 2)
	button:DockMargin(0, 0, 0, 5)
	
	local waypointIcon = Material(waypoint.icon)
	button.Paint = function(panel, width, height)
		Waymap.UI.DrawBlur(panel, width, height)
		
		local iconwidth, iconheight = (height * 0.9), (height * 0.9)
		local x, y = (height * 0.1), (height / 2) - (iconheight / 2)
		surface.SetDrawColor(waypoint.color)
		surface.SetMaterial(waypointIcon)
		surface.DrawTexturedRect(x, y, iconwidth, iconheight)
	end
	
	button.DoClick = function()
		doClick(key)
	end
end

function PANEL:UpdateWaypoints()
	if IsValid(self.waypointList) then
		self.waypointList:Clear()
		
		local globals = Waymap.Waypoint.GetAll()
		local locals = Waymap.Waypoint.GetAllLocal()
		
		for k, waypoint in pairs(globals) do
			self:AddWaypoint(k, waypoint, function(id)
				-- do something here
			end)
		end
		
		for k, waypoint in pairs(locals) do
			self:AddWaypoint(k, waypoint, function(id)
				-- do something here
			end)
		end
	end
end

function PANEL:Think()
	local camera =  Waymap.Camera.GetLoaded()
	
	if not self.requestedMaterial and not self.mapMaterial and camera then
		self.requestedMaterial = true
		
		Waymap.Map.Get(camera, Waymap.Map.selectedMode, function(material)
			self.mapMaterial = material
		end)
	end
end

function PANEL:PerformLayout(width, height)
	if IsValid(self.mapViewPanel) then
		self.mapViewPanel:SetPos(0, 0)
		self.mapViewPanel:SetSize(width, height)
	end
	
	if IsValid(self.waypointList) then
		local newwidth, newheight = (width / 8), (height * 0.9)
		local x, y = (width * 0.85) - (newwidth / 2), (height / 2) - (newheight / 2)
		self.waypointList:SetPos(x, y)
		self.waypointList:SetSize(newwidth, newheight)
	end
end

derma.DefineControl("DWaymap", "Full size map for Waymap", PANEL, "Panel")
