local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	self.requestedMaterial = false
	self.mapMaterial = nil
	
	self.mapViewPanel = vgui.Create("DPanel", self)
	self.mapViewPanel.viewPositionX, self.mapViewPanel.viewPositionY = 0, 0
	self.mapViewPanel.isMovingView = false
	self.mapViewPanel.pressedCursorPositionX, self.mapViewPanel.pressedCursorPositionY = 0, 0
	self.mapViewPanel.pressedViewPositionX, self.mapViewPanel.pressedViewPositionY = 0, 0
	self.mapViewPanel.Paint = function(panel, width, height)
		local camera = Waymap.Camera.GetLoaded()
		
		if camera and self.mapMaterial then
			Waymap.Map.Draw(camera, self.mapMaterial, panel.viewPositionX, panel.viewPositionY, width)
		end
	end
	self.mapViewPanel.OnMousePressed = function(panel, keyCode)
		if keyCode == MOUSE_LEFT then
			panel.pressedCursorPositionX, panel.pressedCursorPositionY = self:LocalCursorPos()
			panel.pressedViewPositionX, panel.pressedViewPositionY = panel.viewPositionX, panel.viewPositionY
			panel.isMovingView = true
		end
	end
	self.mapViewPanel.Think = function(panel)
		if panel.isMovingView then
			if not input.IsMouseDown(MOUSE_LEFT) then
				panel.isMovingView = false
			end
			
			local cursorX, cursorY = self:LocalCursorPos()
			
			panel.viewPositionX = panel.pressedViewPositionX + (cursorX - panel.pressedCursorPositionX)
			panel.viewPositionY = panel.pressedViewPositionY + (cursorY - panel.pressedCursorPositionY)
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

function PANEL:PerformLayout()
	local width, height = self:GetSize()
	
	if IsValid(self.mapViewPanel) then
		self.mapViewPanel:SetPos(0, 0)
		self.mapViewPanel:SetSize(width, height)
	end
end

derma.DefineControl("DWaymap", "Full size map for Waymap", PANEL, "Panel")
