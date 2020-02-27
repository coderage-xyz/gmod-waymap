local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 0)
	
	--[[
	self.frame = vgui.Create("DFrame", self)
	self.frame:SetSize(512, 256)
	self.frame:Center()
	self.frame:MakePopup()
	self.frame:SetSkin("Waymap")
	--]]

	self.waypointTitle = vgui.Create("DTextEntry", self)
	self.waypointTitle:SetSize(120, 32)
	self.waypointTitle:SetPos(2, 0)
	
	self.waypointTitle:SetValue("<insert title here>")

	self.waypointDesc = vgui.Create("DTextEntry", self)
	self.waypointDesc:SetSize(120, 186)
	self.waypointDesc:SetPos(2, 34)
	self.waypointDesc:SetMultiline(true)
	
	self.waypointDesc:SetValue("<insert description here>")

	self.waypointButton = vgui.Create("DWaymapWaypoint", self)
	self.waypointButton:SetSize(110, 220)
	self.waypointButton:SetPos(131, 0)

	self.waypointButton:SetWaypoint{
		name = "Custom Waypoint",
		description = "",
		position = Vector(0, 0, 0),
		color = Color(255, 255, 255),
		icon = "waymap/icons/google/star.png"
	}

	self.waypointMixer = vgui.Create("DColorCombo", self)
	self.waypointMixer:Dock(RIGHT)
	self.waypointMixer:SetColor(Color(255, 255, 255))
	
	self.waypointMixer.OnValueChanged = function(panel, col)
		local waypoint = self.waypointButton:GetWaypoint()
		waypoint.color = col
		self.waypointButton:SetWaypoint(waypoint)
	end
end

function PANEL:Think()
	-- do something here
end

function PANEL:PerformLayout(w, h)
	-- do something here
end

derma.DefineControl("DWaymapWaypointEditor", "Waypoint editor for Waymap", PANEL, "Panel")
