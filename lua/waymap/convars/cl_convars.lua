--[[
	Client convars
--]]

function Waymap.ConVars.CreateClientConVar(...)
    local conVarTable = ...
    local conVar = CreateClientConVar(Waymap.Config.ConVarPrefix .. string.lower(conVarTable.name), conVarTable.value, conVarTable.shouldSave, false, conVarTable.helpText)
    
    Waymap.ConVars[conVarTable.name] = function()
        return  conVar["Get" .. conVarTable.type](conVar)
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

Waymap.ConVars.CreateClientConVar{
    name = "Bezier",
    type = "Bool",
    value = 1,
    helpText = "Enable bezier curves for paths",
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
