local PANEL = {}

function PANEL:Init()
	self:SetTitle(Waymap.Config.Title)
end

derma.DefineControl("DWaymap", "Full size map frame for Waymap", PANEL, "DFrame")