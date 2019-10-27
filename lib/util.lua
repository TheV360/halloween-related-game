-- Some helper functions
-- By V360

local Util = {}

function Util.isNil		(x)	return type(x)=="nil"		end
function Util.isNumber	(x)	return type(x)=="number"	end
function Util.isString	(x)	return type(x)=="string"	end
function Util.isTable	(x)	return type(x)=="table"		end
function Util.isFunction(x)	return type(x)=="function"	end

function Util.round(n)
	return math.floor(n + 0.5)
end

function Util.sine(offset, cycle, height, center)
	height = height or 1
	center = center ~= false
	
	local result = math.sin(2 * math.pi * (offset / cycle))
	
	if center then
		-- From -height to height
		return result * height
	else
		-- From 0 to height
		local halfHeight = (height / 2)
		return halfHeight + (halfHeight * result)
	end
end

function Util.cosine(offset, cycle, height, center)
	height = height or 1
	center = center ~= false
	
	local result = math.cos(2 * math.pi * (offset / cycle))
	
	if center then
		-- From -height to height
		return result * height
	else
		-- From 0 to height
		local halfHeight = (height / 2)
		return halfHeight + (halfHeight * result)
	end
end

function Util.mid(a, b, c)
	return math.min(math.max(a, b), c)
end

function Util.sign(n)
	if n == 0 then return 0 end
	return n > 0 and 1 or -1
end

function Util.lerp(a, b, p)
	return a + (b - a) * p
end

function Util.pointSquare(x1, y1, x2, y2, w2, h2)
	return x1 >= x2 and y1 >= y2 and x1 < x2 + w2 and y1 < y2 + h2
end

function Util.measureText(text)
	local f = love.graphics.getFont()
	
	return f:getWidth(text), f:getHeight()
end

function Util.measureTextWidth(text)
	return love.graphics.getFont():getWidth(text)
end

function Util.measureTextHeight()
	return love.graphics.getFont():getHeight()
end

function Util.copy(obj, seen)
	if type(obj) ~= "table" then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do res[Util.copy(k, s)] = Util.copy(v, s) end
	return res
end

function Util.shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	
	return tbl
end

function Util.stringSplit(str, delimiter, max)
	local result = {}
	local current = 0
	local next = string.find(str, delimiter, current, true)
	
	if not next then return {str} end
	
	repeat
		table.insert(result, string.sub(str, current, next - 1))
		current = next + 1
		
		if max and #result > max then
			break
		end
		
		next = string.find(str, delimiter, current, true)
	until not next
	
	if not (max and #result > max) then
		table.insert(result, string.sub(str, current))
	end
	
	return result
end

function Util.Point(x, y)
	return {x = x or 0, y = y or 0}
end
function Util.PointLength(p)
	return math.sqrt(p.x * p.x + p.y * p.y)
end
function Util.PointNormalize(p)
	local l = Util.PointLength(p)
	if l ~= 0 and l ~= 1 then
		p.x = p.x / l
		p.y = p.y / l
	end
end

function Util.Size(width, height)
	return {width = width or 1, height = height or width or 1}
end

function Util.Rect(x, y, width, height)
	return {position = Point(x, y), size = Size(width, height)}
end

function Util.watch(keyTable, checkFunction)
	local w = {
		downTime = {},
		down = {},
		press = {},
		release = {},
		
		keys = keyTable,
		check = checkFunction
	}
	
	for _, value in ipairs(w.keys) do
		w.downTime[value] = 0
		w.down[value]     = false
		w.press[value]    = false
		w.release[value]  = false
	end
	
	function w:update()
		for _, value in ipairs(self.keys) do
			self.down[value] = self.check(value)
			self.press[value] = false
			self.release[value] = false
			
			if self.down[value] then
				if self.downTime[value] == 0 then
					self.press[value] = true
				end
				self.downTime[value] = self.downTime[value] + 1
			else
				if self.downTime[value] > 0 then
					self.release[value] = true
				end
				self.downTime[value] = 0
			end
		end
	end
	
	return w
end

return Util
