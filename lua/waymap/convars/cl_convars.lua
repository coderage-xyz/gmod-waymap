--[[
	Client convars
--]]

Waymap.ConVars = Waymap.ConVars or {}

function Waymap.ConVars.CreateClientConVar(...)
    local conVarTable = ...
    local conVar = CreateClientConVar(Waymap.Config.ConVarPrefix .. string.lower(conVarTable.name), conVarTable.value, conVarTable.shouldSave, false, conVarTable.helpText)
    
    Waymap.ConVars[conVarTable.name] = function()
        return conVar["Get" .. conVarTable.type](conVar)
    end
end

--[[
Waymap.ConVars.CreateClientConVar{
    name = "Example",
    type = "Bool",
    value = 1,
	shouldSave = true,
    helpText = "Example client convar",
}
]]

--[[
	Path convars
--]]

Waymap.ConVars.CreateClientConVar{
    name = "Path_Method",
    type = "Int",
    value = 2,
    helpText = "Smoothing method to be used on path. 0 = none, 1 = Bézier, 2 = Catmull-Rom",
}

--[[
	Debug convars
--]]

Waymap.ConVars.CreateClientConVar{
    name = "Debug_ShowIcons",
    type = "Bool",
    value = 0,
    helpText = "Show icon debug view",
}
