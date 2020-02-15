Waymap.UI = Waymap.UI or {}
Waymap.UI.waymapFrame = Waymap.UI.waymapFrame or {}

function Waymap.UI.OpenMap()
	if not IsValid(Waymap.UI.waymapFrame) then
		Waymap.UI.waymapFrame = vgui.Create("DWaymap")
		Waymap.UI.waymapFrame:SetSize(ScrW() - 100, ScrH() - 100) 
		Waymap.UI.waymapFrame:Center()
		Waymap.UI.waymapFrame:SetVisible(true) 
		Waymap.UI.waymapFrame:SetDraggable(true) 
		Waymap.UI.waymapFrame:ShowCloseButton(true) 
		--TODO: Set to false
		Waymap.UI.waymapFrame:SetDeleteOnClose(true)
		Waymap.UI.waymapFrame:MakePopup()
	end
end

function Waymap.UI.OpenCameraEditor()
	if not IsValid(Waymap.UI.cameraEditorFrame) then
		Waymap.UI.cameraEditorFrame = vgui.Create("DFrame")
		Waymap.UI.cameraEditorFrame:SetTitle(Waymap.Config.Title)
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
