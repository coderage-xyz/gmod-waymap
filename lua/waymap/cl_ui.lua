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
