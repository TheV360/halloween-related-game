require "common"

--- CLIENT

local client = cs.client

if USE_CASTLE_CONFIG then
	client.useCastleConfig()
else
	client.enabled = true
	client.start("127.0.0.1:22122")
end

local share = client.share
local home = client.home

-- Events

function client.connect() -- Called on connect from server
	print("hi, i'm a client")
	home.move = Util.Point()
end

function client.disconnect() -- Called on disconnect from server
end

function client.receive(...) -- Called when server does `server.send(id, ...)` with our `id`
end

-- Main Loop

function client.load()
	seconds = 0
	
	love.window.setMode(360, 240)
	
	-- Pixel perfect mode
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(1)
	
	-- Load resources
	Object = require("object")
	
	-- Load fonts
	fonts = {
		v360 = love.graphics.newImageFont("resources/font_6x8.png", [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□☺☻←↑→↓]]),
		-- expression = love.graphics.newFont("resources/ExpressionPro.ttf", 16),
		-- matchup = love.graphics.newFont("resources/MatchupPro.ttf", 16),
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

function client.update(dt)
	if client.connected then
		seconds = seconds + dt
		
		buttons:update()
		
		home.move.x = 0
		home.move.y = 0
		if buttons.down.up    then home.move.y = -1 end
		if buttons.down.down  then home.move.y =  1 end
		if buttons.down.left  then home.move.x = -1 end
		if buttons.down.right then home.move.x =  1 end
	end
end

function client.draw()
	love.graphics.clear()
	
	if client.connected then
		love.graphics.setColor(0.25, 0.5, 1)
		love.graphics.rectangle("fill",  share.boxPos.x - 4, share.boxPos.y - 4, 8, 8)
		
		love.graphics.setColor(1, 1, 1)
	else
		love.graphics.print("oh no")
	end
end
