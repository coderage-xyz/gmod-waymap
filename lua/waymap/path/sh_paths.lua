--[[
	Path data/functions shared between server and client
--]]

Waymap.Path = Waymap.Path or {}

--[[
	Utility functions
--]]

--[[
function Waymap.Path.GetPointOnPath(path, ...)
	local args = {...}
	local solutions = {}
	
	local piecewise = {}
	
	local length = Waymap.Path.GetTotalLength(path)
	
	local lengthVisited = 0
	
	for i, node in pairs(path) do
		local last = path[i - 1]
		if last then
			local distance = node:Distance(last)
			
			local piece = {
				posStart = node,
				posEnd = last,
				length = distance,
				lengthUntil = lengthVisited,
				
				progStart = lengthVisited / length,
				progEnd = (lengthVisited + distance) / length
			}
			
			lengthVisited = lengthVisited + distance
			table.insert(piecewise, piece)
		end
	end
	
	for i, arg in pairs(args) do
		for _, piece in pairs(piecewise) do
			if (piece.progStart <= arg) and (piece.progEnd >= arg) then
				local prog = arg - piece.progStart
				print(prog)
				local solution = prog * piece.posStart + (1 - prog) * piece.posEnd
				table.insert(solutions, solution)
			end
		end
	end
	
	return solutions
end
--]]
