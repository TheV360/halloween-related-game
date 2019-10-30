local YSort = {}
YSort.SortFunc = function(a, b) return a.pos.y > b.pos.y end

function YSort.new()
	local s = {}
	
	s.items = {}
end

return YSort
