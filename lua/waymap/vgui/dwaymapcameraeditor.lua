local PANEL = {}

function PANEL:Init()
	local width, height = self:GetSize()
	local min, max = game.GetWorld():GetModelBounds()
	local cameraPositionX, cameraPositionY = 0, 0
	local cameraHeight = math.max(min.z, max.z)
	local zoom = (max.z - min.z) * 4
	local loaded = false
	local rotation = 0
	
	self:SetTitle(Waymap.Config.Title)
	self:SetSize(ScrH(), ScrH() - 200)
	self:Center()
	self:SetDraggable(true) 
	self:ShowCloseButton(true) 
	self:SetDeleteOnClose(true)
	
	self.cameraViewPanel = vgui.Create("DPanel", self)
	self.cameraViewPanel.Paint = function(panel, width, height)
		local x, y = panel:LocalToScreen(0, 0)
		
		render.RenderView({
			origin = Vector(-cameraPositionY, -cameraPositionX, math.max(min.z, max.z)),
			angles = Angle(90, math.floor(rotation) * 90, 0),
			x = x,
			y = y,
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
				left = -zoom,
				right = zoom,
				top = -zoom,
				bottom = zoom
			}
		})
	end
	
	self.optionsScrollPanel = vgui.Create( "DScrollPanel", self)
	self.optionsScrollPanel:SetPaintBackground(true)
	
	self.optionsForm = vgui.Create("DForm", self.optionsScrollPanel)
	self.optionsForm:SetName("Options")
	self.optionsForm:Dock(FILL)
	
	local maxPosition = math.max(min.x - max.x, max.x - min.x, min.y - max.y, max.y - min.y)
	
	self.cameraPositionXSlider = self.optionsForm:NumSlider("Postion X", "", -maxPosition, maxPosition, 0)
	self.cameraPositionXSlider.OnValueChanged = function(slider, value)
		if loaded then
			cameraPositionX = value
		end
	end
	
	self.cameraPositionYSlider = self.optionsForm:NumSlider("Postion Y", "", -maxPosition, maxPosition, 0)
	self.cameraPositionYSlider.OnValueChanged = function(slider, value)
		if loaded then
			cameraPositionY = value
		end
	end
	
	self.cameraPositionZoomSlider = self.optionsForm:NumSlider("Zoom", "", -zoom, zoom, 0)
	self.cameraPositionZoomSlider.OnValueChanged = function(slider, value)
		if loaded then
			zoom = value
		end
	end
	
	self.cameraPositionRotationSlider = self.optionsForm:NumSlider("Rotation", "", 0, 3, 0)
	self.cameraPositionRotationSlider.OnValueChanged = function(slider, value)
		if loaded then
			rotation = value
		end
	end
	
	self.buttonSave = self.optionsForm:Button("Save", "")
	self.buttonSave.DoClick = function(button)
		
	end
	
	timer.Simple(0, function()
		if IsValid(self.cameraPositionXSlider) then
			self.cameraPositionXSlider:SetValue(cameraPositionX)
		end
		
		if IsValid(self.cameraPositionYSlider) then
			self.cameraPositionYSlider:SetValue(cameraPositionY)
		end
		
		if IsValid(self.cameraPositionZoomSlider) then
			self.cameraPositionZoomSlider:SetValue(zoom)
		end
		
		if IsValid(self.cameraPositionRotationSlider) then
			self.cameraPositionRotationSlider:SetValue(rotation)
		end
		
		loaded = true
	end)
end

function PANEL:PerformLayout()
	local width, height = self:GetSize()
	
	local titlePush = 0
	
	if IsValid(self.imgIcon) then
		self.imgIcon:SetPos(5, 5)
		self.imgIcon:SetSize(16, 16)
		titlePush = 16
	end
	
	self.btnClose:SetPos(width - 31 - 4, 0)
	self.btnClose:SetSize(31, 24)
	
	self.btnMaxim:SetPos(width - 31 * 2 - 4, 0)
	self.btnMaxim:SetSize(31, 24)
	
	self.btnMinim:SetPos(width - 31 * 3 - 4, 0)
	self.btnMinim:SetSize(31, 24)
	
	self.lblTitle:SetPos(8 + titlePush, 2)
	self.lblTitle:SetSize(width - 25 - titlePush, 20)
	
	if IsValid(self.cameraViewPanel) then
		self.cameraViewPanel:SetPos(226, 26)
		self.cameraViewPanel:SetSize(height - 29, height - 29)
	end
	
	if IsValid(self.optionsForm) then
		self.optionsScrollPanel:SetPos(3, 26)
		self.optionsScrollPanel:SetSize(222, height - 29)
	end
end

derma.DefineControl("DWaymapCameraEditor", "Map camera editor for Waymap", PANEL, "DFrame")
