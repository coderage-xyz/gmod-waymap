local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	
	self.titleEntry = vgui.Create("DTextEntry", self)
	self.titleEntry:SetValue("")
	self.titleEntry:SetPlaceholderText("Title")
	
	self.waypointPreview = vgui.Create("DWaymapWaypoint", self)
	--[[self.waypointPreview.Paint = function(panel, width, height)
		surface.SetDrawColor(255,255,255,255)
   		surface.DrawRect(0, 0, width, height)
	end]]
	
	self.descriptionEntry = vgui.Create("DTextEntry", self)
	self.descriptionEntry:SetValue("")
	self.descriptionEntry:SetMultiline(true)
	self.descriptionEntry:SetPlaceholderText("Description")
	
	self.waypointPreview:SetWaypoint{
		name = "Custom Waypoint",
		description = "",
		position = Vector(0, 0, 0),
		color = Color(255, 255, 255),
		icon = "waymap/icons/google/star.png"
	}
	
	self.waypointMixer = vgui.Create("DColorCombo", self)
	self.waypointMixer:SetColor(Color(255, 255, 255))
	self.waypointMixer.OnValueChanged = function(panel, col)
		local waypoint = self.waypointPreview:GetWaypoint()
		waypoint.color = col
		
		self.waypointPreview:SetWaypoint(waypoint)
	end
	
	self.iconOrModelEntry = vgui.Create("DTextEntry", self)
	self.iconOrModelEntry:SetPlaceholderText("Icon or model")
	
	for pathAndName, material in pairs(Waymap.UI.GetAllIcons()) do
		self.iconOrModelEntry:SetValue(pathAndName)
		
		break
	end
	
	self.iconsAndModelsSheet = vgui.Create("DPropertySheet", self)

	self.iconsPanel = vgui.Create("DPanel", self.iconsAndModelsSheet)
	self.iconsPanel.Paint = function(panel, width, height)
		
	end
	self.iconsAndModelsSheet:AddSheet("Icons", self.iconsPanel, "icon16/picture.png")
	
	self.iconsScroll = vgui.Create("DHorizontalScroller", self.iconsPanel)
	self.iconsScroll:Dock(FILL)
	self.iconsScroll:SetOverlap(-4)
	
	for pathAndName, material in pairs(Waymap.UI.GetAllIcons()) do
		local icon = vgui.Create("DImageButton")
		icon:SetImage(pathAndName)
		icon:SetSize(64, 64)
		icon.Think = function(panel)
			panel:SetColor(self.waypointMixer:GetColor())
		end
		icon.DoClick = function(panel)
			self.iconOrModelEntry:SetValue(pathAndName)
			
			local waypoint = self.waypointPreview:GetWaypoint()
			waypoint.icon = pathAndName
			
			self.waypointPreview:SetWaypoint(waypoint)
		end
		self.iconsScroll:AddPanel(icon)
	end
	
	self.modelsPanel = vgui.Create("DPanel", self.iconsAndModelsSheet)
	self.modelsPanel.Paint = function(panel, width, height)
		
	end
	self.iconsAndModelsSheet:AddSheet("Models", self.modelsPanel, "icon16/brick.png")
	
	self.modelsScroll = vgui.Create("DHorizontalScroller", self.modelsPanel)
	self.modelsScroll:Dock(FILL)
	self.modelsScroll:SetOverlap(-4)
	
	for iconModelIndex, iconModel in ipairs(Waymap.Config.IconModels) do
		local icon = vgui.Create("SpawnIcon")
		icon:SetModel(iconModel)
		icon:SetSize(64, 64)
		icon.DoClick = function(panel)
			self.iconOrModelEntry:SetValue(iconModel)
		end
		self.modelsScroll:AddPanel(icon)
	end
	
	self.createButton = vgui.Create("DButton", self)
	self.createButton:SetText("Create")
	self.createButton.DoClick = function()
		Waymap.Waypoint.AddLocal(self.titleEntry:GetValue(), self.descriptionEntry:GetValue(), LocalPlayer():GetPos(), self.waypointMixer:GetColor(), self.iconOrModelEntry:GetValue())
	end
end

function PANEL:Think()
	
end

function PANEL:PerformLayout(width, height)
	self.titleEntry:SetPos(2, 0)
	self.titleEntry:SetSize(146, 22)
	
	self.waypointPreview:SetPos(20, 26)
	self.waypointPreview:SetSize(110, 220)
	
	self.descriptionEntry:SetPos(2, 250)
	self.descriptionEntry:SetSize(146, height - 252)
	
	self.waypointMixer:SetPos(152, 0)
	self.waypointMixer:SetSize(width - 154, height - 132)
	
	self.iconsAndModelsSheet:SetPos(152, height - 128)
	self.iconsAndModelsSheet:SetSize(width - 154, 100)
	
	self.iconOrModelEntry:SetPos(152, height - 24)
	self.iconOrModelEntry:SetSize(width - 258, 22)
	
	self.createButton:SetPos(width - 102, height - 24)
	self.createButton:SetSize(100, 22)
end

derma.DefineControl("DWaymapWaypointEditor", "Waypoint editor for Waymap", PANEL, "Panel")
