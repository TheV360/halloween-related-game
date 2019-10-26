function love.load()
	seconds = 0
	
	love.window.setMode(360, 240)
	
	-- Pixel perfect mode
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(1)
	
	-- Load resources
	Object = require("object")
	Util = require("util")
	
	-- Load fonts
	fonts = {
		v360 = love.graphics.newImageFont("resources/font_6x8.png", [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□☺☻←↑→↓]]),
		expression = love.graphics.newFont("resources/ExpressionPro.ttf", 16),
		matchup = love.graphics.newFont("resources/MatchupPro.ttf", 16),
	}
	
	love.graphics.setFont(fonts.v360)
	
	buttons = Util.watch({"up", "down", "left", "right", "a", "b", "pause"}, function(key) return love.keyboard.isDown(buttonMap[key]) end)
	buttonMap = {
		up    = "up",
		down  = "down",
		left  = "left",
		right = "right",
		a     = "z",
		b     = "x",
		pause = "return"
	}
end

function love.update(dt)
	seconds = seconds + dt
end

function love.draw()
end
