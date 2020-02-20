local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	self.requestedMaterial = false
	self.mapMaterial = nil
	
	self.mapViewPanel = vgui.Create("DPanel", self)
	self.mapViewPanel.viewPositionX = 0
	self.mapViewPanel.viewPositionY = -500
	self.mapViewPanel.Paint = function(panel, width, height)
		local camera = Waymap.Camera.GetLoaded()
		
		if camera and self.mapMaterial then
			Waymap.Map.Draw(camera, self.mapMaterial, panel.viewPositionX, panel.viewPositionY, width)
		end
	end
end

function PANEL:Think()
	if not self.requestedMaterial and not self.mapMaterial and Waymap.Camera.loadedCamera then
		self.requestedMaterial = true
		
		Waymap.Map.Get(Waymap.Camera.loadedCamera, Waymap.Map.selectedMode, function(material)
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

derma.DefineControl("DWaymap", "Full size map for Waymap", PANEL, "DPanel")
