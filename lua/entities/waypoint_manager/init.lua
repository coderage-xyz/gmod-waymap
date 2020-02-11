AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

--[[
	Pathfinding algorithms
--]]

function ENT:Astar(start, goal)
    if (not IsValid(start) or not IsValid(goal)) then return false end
    if (start == goal) then return true end

    start:ClearSearchLists()

    start:AddToOpenList()

    local cameFrom = {}

    start:SetCostSoFar(0)

    start:SetTotalCost(self:heuristic_cost_estimate(start, goal))
    start:UpdateOnOpenList()

    while (!start:IsOpenListEmpty()) do
        local current = start:PopOpenList() -- Remove the area with lowest cost in the open list and return it
        if (current == goal) then
            return self:reconstruct_path(cameFrom, current)
        end

        current:AddToClosedList()

        for k, neighbor in pairs(current:GetAdjacentAreas()) do
            local newCostSoFar = current:GetCostSoFar() + self:heuristic_cost_estimate(current, neighbor)

            if (neighbor:IsUnderwater()) then -- Add your own area filters or whatever here
                continue
            end

            if ((neighbor:IsOpen() or neighbor:IsClosed()) and neighbor:GetCostSoFar() <= newCostSoFar) then
                continue
            else
                neighbor:SetCostSoFar(newCostSoFar)
                neighbor:SetTotalCost(newCostSoFar + self:heuristic_cost_estimate(neighbor, goal))

                if (neighbor:IsClosed()) then
                    neighbor:RemoveFromClosedList()
                end

                if (neighbor:IsOpen()) then
                    -- This area is already on the open list, update its position in the list to keep costs sorted
                    neighbor:UpdateOnOpenList()
                else
                    neighbor:AddToOpenList()
                end

                cameFrom[neighbor:GetID()] = current:GetID()
            end
        end
    end

    return false
end

function ENT:heuristic_cost_estimate(start, goal)
    -- Perhaps play with some calculations on which corner is closest/farthest or whatever
    return start:GetCenter():Distance(goal:GetCenter())
end

-- using CNavAreas as table keys doesn't work, we use IDs
function ENT:reconstruct_path(cameFrom, current)
    local total_path = {current}

    current = current:GetID()
    while (cameFrom[current]) do
        current = cameFrom[current]
        table.insert(total_path, navmesh.GetNavAreaByID(current))
    end
    return total_path
end

--[[
	Additional pathfinding functions
--]]

function ENT:AstarVector(start, goal)
    local startArea = navmesh.GetNearestNavArea(start)
    local goalArea = navmesh.GetNearestNavArea(goal)
    return self:Astar(startArea, goalArea)
end

--[[
	Entity functions
--]]

function ENT:Initialize()
end
