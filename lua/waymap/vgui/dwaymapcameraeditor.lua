local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	
	local min, max = game.GetWorld():GetModelBounds()
	local loaded = false
	
	Waymap.Camera.RequestFromServer(function(camera)
		self.cameraViewPanel = vgui.Create("DPanel", self)
		self.cameraViewPanel.Paint = function(panel, width, height)
			local x, y = panel:LocalToScreen(0, 0)
			
			render.RenderView({
				origin = Vector(-camera.position.y, -camera.position.x, camera.position.z),
				angles = Angle(90, camera.rotation * 90, 0),
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
		self.optionsForm:SetName("Camera Options")
		self.optionsForm:Dock(FILL)
		
		local maxPosition = math.max(min.x - max.x, max.x - min.x, min.y - max.y, max.z - min.z)
		local maxZoom = (max.z - min.z) * 4
		
		self.cameraPositionXSlider = self.optionsForm:NumSlider("Postion X", "", -maxPosition, maxPosition, 0)
		self.cameraPositionXSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.position.x = math.floor(value)
			end
		end
		
		self.cameraPositionYSlider = self.optionsForm:NumSlider("Postion Y", "", -maxPosition, maxPosition, 0)
		self.cameraPositionYSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.position.y = math.floor(value)
			end
		end
		
		self.optionsForm:Help("Only change position Z if the 3D skybox is in the way or the map is displayed incorrectly")
		
		self.cameraPositionZSlider = self.optionsForm:NumSlider("Postion Z", "", -maxPosition, maxPosition, 0)
		self.cameraPositionZSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.position.z = math.floor(value)
			end
		end
		
		self.cameraPositionZoomSlider = self.optionsForm:NumSlider("Zoom", "", -maxPosition, maxPosition, 0)
		self.cameraPositionZoomSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.zoom = math.floor(value)
			end
		end
		
		self.cameraPositionRotationSlider = self.optionsForm:NumSlider("Rotation", "", 0, 3, 0)
		self.cameraPositionRotationSlider.OnValueChanged = function(slider, value)
			if loaded then
				camera.rotation = math.floor(value)
			end
		end
		
		self.buttonSave = self.optionsForm:Button("Save", "")
		self.buttonSave.DoClick = function(button)
			Waymap.Camera.SaveCameraToServer(camera)
			Waymap.UI.CloseCameraEditor()
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
	
	if IsValid(self.cameraViewPanel) then
		self.cameraViewPanel:SetPos(226, 0)
		self.cameraViewPanel:SetSize(height - 3, height - 3)
	end
	
	if IsValid(self.optionsForm) then
		self.optionsScrollPanel:SetPos(3, 0)
		self.optionsScrollPanel:SetSize(221, height - 3)
	end
end

derma.DefineControl("DWaymapCameraEditor", "Map camera editor for Waymap", PANEL, "Panel")
Waymap.UI.OpenCameraEditor()