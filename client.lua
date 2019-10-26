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
	home.me = castle.user.getMe()
	home.move = Util.Point()
	home.ready = true
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
	seconds = seconds + dt
	
	if client.connected then
		buttons:update()
		
		home.move.x = 0
		home.move.y = 0
		if buttons.down.up    then home.move.y = -1 end
		if buttons.down.down  then home.move.y =  1 end
		if buttons.down.left  then home.move.x = -1 end
		if buttons.down.right then home.move.x =  1 end
		Util.PointNormalize(home.move)
	end
end

function client.draw()
	love.graphics.clear()
	
	if client.connected then
		love.graphics.setColor(1, 1, 1)
		for _, player in pairs(share.players) do
			drawPlayer(player, player.id == client.id)
		end
	else
		if seconds > 5 then
			love.graphics.print("Uh... something broke.", 0, 0)
			love.graphics.print("Maybe close the game and reopen?", 0, 8)
		else
			local msg = "connecting..."
			
			for i = 1, #msg do
				love.graphics.print(string.sub(msg, i, i), (128 - #msg*4) + (i * 8), 96 + Util.sine(seconds + (i / #msg), 5, 32))
			end
		end
	end
end

-- Util

function drawPlayer(player, isClient)
	if player.me then
		if not player.photo then
			player.photo = true
			network.async(function()
				player.photo = love.graphics.newImage(player.me.photoUrl)
			end)
		end
	end
	
	if player.photo and player.photo ~= true then
		love.graphics.draw(player.photo, player.x - (PLAYER_SIZE / 2), player.y - (PLAYER_SIZE / 2), 0, PLAYER_SIZE / player.photo:getWidth(), PLAYER_SIZE / player.photo:getWidth())
	else
		love.graphics.rectangle("fill", player.x - (PLAYER_SIZE / 2), player.y - (PLAYER_SIZE / 2), PLAYER_SIZE, PLAYER_SIZE)
	end
end
