local PANEL = {}

--[[
	Waypoint functions
--]]

function PANEL:SetWaypoint(waypoint)
	self._waypoint = waypoint
end

function PANEL:GetWaypoint()
	return self._waypoint
end

--[[
	Native panel functions
--]]

function PANEL:Init()
	self:SetText("")
end

function PANEL:Think()
	-- do code
end

function PANEL:PerformLayout(w, h)
	-- do code
end

function PANEL:Paint(w, h)
	local waypoint = self:GetWaypoint()
	if waypoint then
		Waymap.UI.DrawWaypoint(0, 0, w, h, waypoint.icon, waypoint.color)
	end
end

derma.DefineControl("DWaymapWaypoint", "A derivation of DButton for Waymap's Waypoints", PANEL, "DButton")
