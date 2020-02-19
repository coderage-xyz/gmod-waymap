Waymap.UI = Waymap.UI or {}
Waymap.UI.waymapFrame = Waymap.UI.waymapFrame or {}

local blur = Material("pp/blurscreen")

function Waymap.UI.OpenMap()
	if not IsValid(Waymap.UI.waymapFrame) then
		Waymap.UI.waymapFrame = vgui.Create("DFrame")
		Waymap.UI.waymapFrame:SetTitle(Waymap.Config.Title)
		Waymap.UI.waymapFrame:SetSize(ScrW() - 100, ScrH() - 100)
		Waymap.UI.waymapFrame:Center()
		Waymap.UI.waymapFrame:DockPadding(0, 26, 0, 0)
		Waymap.UI.waymapFrame:SetSkin("Waymap")
		Waymap.UI.waymapFrame:SetDraggable(true)
		Waymap.UI.waymapFrame:ShowCloseButton(true)
		--TODO: Set to false
		Waymap.UI.waymapFrame:SetDeleteOnClose(true)
		Waymap.UI.waymapFrame:SetVisible(true)
		Waymap.UI.waymapFrame:MakePopup()
		
		function Waymap.UI.waymapFrame:Paint(w, h)
			local x, y = self:LocalToScreen(0, 0)
			
			surface.SetDrawColor(Color(0, 0, 0, 200))
			surface.DrawRect(0, 0, w, h)
			
			surface.SetDrawColor(255, 255, 255, 150)
			surface.SetMaterial(blur)

			for i = 1, 5 do
				blur:SetFloat("$blur", (i / 4) * 4)
				blur:Recompute()

				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
			end
		end
		
		Waymap.UI.waymapFrame.waymap = vgui.Create("DWaymap", Waymap.UI.waymapFrame)
		Waymap.UI.waymapFrame.waymap:Dock(FILL)
	end
end

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
		
		Waymap.UI.cameraEditorFrame.cameraEditor = vgui.Create("DWaymapCameraEditor", Waymap.UI.cameraEditorFrame)
		Waymap.UI.cameraEditorFrame.cameraEditor:Dock(FILL)
	end
end

function Waymap.UI.CloseCameraEditor()
	if IsValid(Waymap.UI.cameraEditorFrame) then
		Waymap.UI.cameraEditorFrame:Remove()
	end
end

concommand.Add("waymap_openmap",function(ply, cmd, args)
    Waymap.UI.OpenMap()
end)

concommand.Add("waymap_opencameraeditor",function(ply, cmd, args)
    Waymap.UI.OpenCameraEditor()
end)
