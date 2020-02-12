--[[
	Server convars
--]]

Waymap.ConVars = Waymap.ConVars or {}

function Waymap.ConVars.CreateServerConVar(...)
    local conVarTable = ...
    local conVar = CreateConVar(Waymap.Config.ConVarPrefix .. string.lower(conVarTable.name), conVarTable.value, conVarTable.flags, conVarTable.helpText)
    
    Waymap.ConVars[conVarTable.name] = function()
        return  conVar["Get" .. conVarTable.type](conVar)
    end
end

--[[
Waymap.ConVars.CreateClientConVar{
    name = "Example",
    type = "Bool",
    value = 1,
	flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Example server convar",
}
]]
