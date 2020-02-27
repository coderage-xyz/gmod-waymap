Waymap.UI = Waymap.UI or {}
Waymap.UI.waymapFrame = Waymap.UI.waymapFrame or {}

--[[
	Blur texture drawing functions
--]]

local blur = Material("pp/blurscreen")

function Waymap.UI.DrawBlur(panel, w, h, count)
	count = count or 5
	local x, y = panel:LocalToScreen(0, 0)
	
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawRect(0, 0, w, h)
	
	surface.SetDrawColor(255, 255, 255, 150)
	surface.SetMaterial(blur)

	for i = 1, count do
		blur:SetFloat("$blur", (i / 4) * 4)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end

--[[
	Map menu functions
--]]

function Waymap.UI.OpenMap()
	if not IsValid(Waymap.UI.waymapFrame) then
		Waymap.UI.waymapFrame = vgui.Create("DFrame")
		Waymap.UI.waymapFrame:SetTitle(Waymap.Config.Title)
		Waymap.UI.waymapFrame:SetSize(ScrW(), ScrH())
		Waymap.UI.waymapFrame:Center()
		Waymap.UI.waymapFrame:DockPadding(0, 26, 0, 0)
		Waymap.UI.waymapFrame:SetSkin("Waymap")
		Waymap.UI.waymapFrame:SetDraggable(false)
		Waymap.UI.waymapFrame:ShowCloseButton(true)
		--TODO: Set to false
		Waymap.UI.waymapFrame:SetDeleteOnClose(true)
		Waymap.UI.waymapFrame:SetVisible(true)
		Waymap.UI.waymapFrame:MakePopup()
		
		Waymap.UI.waymapFrame.Paint = Waymap.UI.DrawBlur
		
		Waymap.UI.waymapFrame.waymap = vgui.Create("DWaymap", Waymap.UI.waymapFrame)
		Waymap.UI.waymapFrame.waymap:Dock(FILL)
	end
end

--[[
	Camera editor menu functions
--]]

function Waymap.UI.OpenCameraEditor()
	if not IsValid(Waymap.UI.cameraEditorFrame) then
		Waymap.UI.cameraEditorFrame = vgui.Create("DFrame")
		Waymap.UI.cameraEditorFrame:SetTitle(Waymap.Config.Title .. " - Camera Editor")
		Waymap.UI.cameraEditorFrame:SetSize(ScrH(), ScrH() - 200)
		Waymap.UI.cameraEditorFrame:Center()
		Waymap.UI.cameraEditorFrame:DockPadding(0, 26, 0, 0)
		Waymap.UI.cameraEditorFrame:SetSkin("Waymap")
		Waymap.UI.cameraEditorFrame:SetDraggable(true)
		Waymap.UI.cameraEditorFrame:ShowCloseButton(true)
		Waymap.UI.cameraEditorFrame:SetDeleteOnClose(true)
		Waymap.UI.cameraEditorFrame:SetVisible(true)
		Waymap.UI.cameraEditorFrame:MakePopup()
		
		Waymap.UI.cameraEditorFrame.Paint = Waymap.UI.DrawBlur
		
		Waymap.UI.cameraEditorFrame.cameraEditor = vgui.Create("DWaymapCameraEditor", Waymap.UI.cameraEditorFrame)
		Waymap.UI.cameraEditorFrame.cameraEditor:Dock(FILL)
	end
end

function Waymap.UI.CloseCameraEditor()
	if IsValid(Waymap.UI.cameraEditorFrame) then
		Waymap.UI.cameraEditorFrame:Remove()
	end
end

--[[
	Waypoint editor menu functions
--]]

function Waymap.UI.OpenWaypointEditor()
	if not IsValid(Waymap.UI.waypointEditorFrame) then
		Waymap.UI.waypointEditorFrame = vgui.Create("DFrame")
		Waymap.UI.waypointEditorFrame:SetTitle("Waypoint Editor")
		Waymap.UI.waypointEditorFrame:SetSize(512, 256)
		Waymap.UI.waypointEditorFrame:Center()
		
		-- TODO: Set to false
		Waymap.UI.waypointEditorFrame:SetDeleteOnClose(true)
		Waymap.UI.waypointEditorFrame:SetVisible(true)
		Waymap.UI.waypointEditorFrame:MakePopup()
		
		Waymap.UI.waypointEditorFrame.Paint = Waymap.UI.DrawBlur
		
		Waymap.UI.waypointEditorFrame.editor = vgui.Create("DWaymapWaypointEditor", Waymap.UI.waypointEditorFrame)
		Waymap.UI.waypointEditorFrame.editor:Dock(FILL)
	end
end

function Waymap.UI.CloseWaypointEditor()
	if IsValid(Waymap.UI.waypointEditorFrame) then
		Waymap.UI.waypointEditorFrame:Remove()
	end
end

--[[
	Console commands (concommands)
--]]

concommand.Add("waymap_openmap",function(ply, cmd, args)
    Waymap.UI.OpenMap()
end)

concommand.Add("waymap_opencameraeditor",function(ply, cmd, args)
    Waymap.UI.OpenCameraEditor()
end)

-- TODO: Remove this
concommand.Add("waymap_openwaypointeditor", function(ply, cmd, args)
	Waymap.UI.OpenWaypointEditor()
end)
