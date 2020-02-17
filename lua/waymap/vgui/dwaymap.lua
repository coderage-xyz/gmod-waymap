local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	self.requestedMaterial = false
	self.mapMaterial = nil
	
	self.mapViewPanel = vgui.Create("DPanel", self)
	self.mapViewPanel.Paint = function(panel, width, height)
		if self.mapMaterial then
			Waymap.Map.Draw(self.mapMaterial, 0, 0, width, height)
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
		self.mapViewPanel:SetSize(height, height)
	end
end

derma.DefineControl("DWaymap", "Full size map for Waymap", PANEL, "Panel")
