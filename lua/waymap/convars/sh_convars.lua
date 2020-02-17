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
Waymap.ConVars.CreateServerConVar{
    name = "Example",
    type = "Bool",
    value = 1,
	flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Example server convar",
}
]]

Waymap.ConVars.CreateServerConVar{
    name = "DefaultMapMode",
    type = "String",
    value = "SATELLITE",
	flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Default mode for viewing the map. Possible values: \"SATELLITE\" or \"FLAT\"",
}

Waymap.ConVars.CreateServerConVar{
	name = "Debug",
	type = "Bool",
	value = "0",
	flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
	helpText = "Whether or not to enable verbose logging."
}
