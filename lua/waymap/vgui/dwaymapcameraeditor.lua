local PANEL = {}

function PANEL:Init()
	self:SetTitle(Waymap.Config.Title)
	self:SetSize(ScrH(), ScrH() - 200)
	self:Center()
	self:SetDraggable(true) 
	self:ShowCloseButton(true) 
	self:SetDeleteOnClose(true)
	
	local min, max = game.GetWorld():GetModelBounds()
	local loaded = false
	
	Waymap.Camera.RequestFromServer(function(camera)
		self.cameraViewPanel = vgui.Create("DPanel", self)
		self.cameraViewPanel.Paint = function(panel, width, height)
			local x, y = panel:LocalToScreen(0, 0)
			
			render.RenderView({
				origin = camera.position,
				angles = Angle(90, math.floor(camera.rotation) * 90, 0),
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
					left = -camera.zoom,
					right = camera.zoom,
					top = -camera.zoom,
					bottom = camera.zoom
				}
			})
		end
		
		self.optionsScrollPanel = vgui.Create( "DScrollPanel", self)
		self.optionsScrollPanel:SetPaintBackground(true)
		
		self.optionsForm = vgui.Create("DForm", self.optionsScrollPanel)
		self.optionsForm:SetName("Options")
		self.optionsForm:Dock(FILL)
		
		local maxPosition = math.max(min.x - max.x, max.x - min.x, min.y - max.y, max.z - min.z)
		local maxZoom = (max.z - min.z) * 4
		
		self.cameraPositionXSlider = self.optionsForm:NumSlider("Postion X", "", -maxPosition, maxPosition, 0)
		self.cameraPositionXSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.position.x = value
			end
		end
		
		self.cameraPositionYSlider = self.optionsForm:NumSlider("Postion Y", "", -maxPosition, maxPosition, 0)
		self.cameraPositionYSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.position.y = value
			end
		end
		
		self.cameraPositionZSlider = self.optionsForm:NumSlider("Postion Z", "", -maxPosition, maxPosition, 0)
		self.cameraPositionZSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.position.z = value
			end
		end
		
		self.cameraPositionZoomSlider = self.optionsForm:NumSlider("Zoom", "", -maxPosition, maxPosition, 0)
		self.cameraPositionZoomSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.zoom = value
			end
		end
		
		self.cameraPositionRotationSlider = self.optionsForm:NumSlider("Rotation", "", 0, 3, 0)
		self.cameraPositionRotationSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.rotation = value
			end
		end
		
		self.buttonSave = self.optionsForm:Button("Save", "")
		self.buttonSave.DoClick = function(button)
			if Waymap.Config.CanEditMapCamera(LocalPlayer()) then
				Waymap.Camera.SaveCameraToServer(camera)
			else
				notification.AddLegacy("You do not have permission to edit the map camera!", NOTIFY_ERROR, 4)
				surface.PlaySound("buttons/button11.wav")
			end
		end
		
		--Add extra space at end
		self.optionsForm:Help("")
		
		timer.Simple(0.1, function()
			if IsValid(self.cameraPositionXSlider) then
				self.cameraPositionXSlider:SetValue(camera.position.x)
			end
			
			if IsValid(self.cameraPositionYSlider) then
				self.cameraPositionYSlider:SetValue(camera.position.y)
			end
			
			if IsValid(self.cameraPositionZSlider) then
				self.cameraPositionZSlider:SetValue(camera.position.z)
			end
			
			if IsValid(self.cameraPositionZoomSlider) then
				self.cameraPositionZoomSlider:SetValue(camera.zoom)
			end
			
			if IsValid(self.cameraPositionRotationSlider) then
				self.cameraPositionRotationSlider:SetValue(camera.rotation)
			end
			
			loaded = true
		end)
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
