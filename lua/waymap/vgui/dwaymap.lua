local PANEL = {}

function PANEL:Init()
	self:SetTitle(Waymap.Config.Title)
end

function PANEL:Paint(width, height)
	local x, y = self:GetPos()
	local min, max = game.GetWorld():GetModelBounds()
	
	render.RenderView({
		origin = Vector(0, 0, math.max(min.z, max.z)),
		angles = Angle(90, 0, 0),
		x = x,
		y = y,
		w = height,
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

derma.DefineControl("DWaymap", "Full size map frame for Waymap", PANEL, "DFrame")
