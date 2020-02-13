local PANEL = {}

function PANEL:Init()
	self:SetTitle(Waymap.Config.Title)
	self:SetSize(ScrH(), ScrH() - 100)
	self:Center()
	self:SetDraggable(true) 
	self:ShowCloseButton(true) 
	self:SetDeleteOnClose(true)
	
	self.cameraViewPanel = vgui.Create("DPanel", self)
	self.cameraViewPanel:SetPos(100, 100)
	self.cameraViewPanel:SetSize(200, 200)
	self.cameraViewPanel.Paint = function(panel, width, height)
		local x, y = self:GetPos()
		local min, max = game.GetWorld():GetModelBounds()
		
		render.RenderView({
			origin = Vector(0, 0, math.max(min.z, max.z)),
			angles = Angle(90, 0, 0),
			x = x,
			y = y,
			w = width,
			h = height,
			drawhud = false,
			drawmonitors = false,
			drawviewmodel = false,
			viewmodelfov = false,
			drawhud = false,
			bloomtone = false,
			dopostprocess = false,
			ortho = {
				left = -10000,
				right = 10000,
				top = -10000,
				bottom = 10000
			}
		})
	end
end

derma.DefineControl("DWaymapCameraEditor", "Map camera editor for Waymap", PANEL, "DFrame")
