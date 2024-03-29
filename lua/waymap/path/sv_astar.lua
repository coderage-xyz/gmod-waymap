--[[
	Pathfinding algorithms
--]]

Waymap.Path = Waymap.Path or {}

local function heuristic_cost_estimate(start, goal)
    -- Perhaps play with some calculations on which corner is closest/farthest or whatever
    return start:GetCenter():Distance(goal:GetCenter())
end

-- using CNavAreas as table keys doesn't work, we use IDs
local function reconstruct_path(cameFrom, current)
    local total_path = {current}

    current = current:GetID()
    while (cameFrom[current]) do
        current = cameFrom[current]
        table.insert(total_path, navmesh.GetNavAreaByID(current))
    end
    return total_path
end

function Waymap.Path.Astar(start, goal)
    if (not IsValid(start) or not IsValid(goal)) then return false end
    if (start == goal) then return true end

    start:ClearSearchLists()

    start:AddToOpenList()

    local cameFrom = {}

    start:SetCostSoFar(0)

    start:SetTotalCost(heuristic_cost_estimate(start, goal))
    start:UpdateOnOpenList()

    while (!start:IsOpenListEmpty()) do
        local current = start:PopOpenList() -- Remove the area with lowest cost in the open list and return it
        if (current == goal) then
            return reconstruct_path(cameFrom, current)
        end

        current:AddToClosedList()

        for k, neighbor in pairs(current:GetAdjacentAreas()) do
            local newCostSoFar = current:GetCostSoFar() + heuristic_cost_estimate(current, neighbor)

            if (neighbor:IsUnderwater()) then -- Add your own area filters or whatever here
                continue
            end

            if ((neighbor:IsOpen() or neighbor:IsClosed()) and neighbor:GetCostSoFar() <= newCostSoFar) then
                continue
            else
                neighbor:SetCostSoFar(newCostSoFar)
                neighbor:SetTotalCost(newCostSoFar + heuristic_cost_estimate(neighbor, goal))

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

--[[
	Additional pathfinding functions
--]]

function Waymap.Path.AstarVector(start, goal)
    local startArea = navmesh.GetNearestNavArea(start)
    local goalArea = navmesh.GetNearestNavArea(goal)
    return Waymap.Path.Astar(startArea, goalArea)
end

function Waymap.ConvertAreasToVectors(path)
	if not istable(path) then return end -- path can be a boolean if the destination is the same as start pos
	
	local vectors = {}
	
	local last
	for i, area in pairs(path) do
		last = vectors[#vectors]
		
		--if last then
			--table.insert(vectors, area:GetClosestPointOnArea(last))
		--else
			table.insert(vectors, area:GetCenter())
	--end
	end
	
	return vectors
end
