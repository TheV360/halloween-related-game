require "game/common"

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
	clientPlayer.id = client.id
	
	home.pos = Util.Point(clientPlayer.pos.x, clientPlayer.pos.y)
end

function client.disconnect() -- Called on disconnect from server
end

function client.receive(...) -- Called when server does `server.send(id, ...)` with our `id`
end

-- Main Loop

function client.load()
	seconds = 0
	
	-- Pixel perfect mode
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(1)
	
	-- Load fonts
	fonts = { v360 = love.graphics.newImageFont("resources/font_6x8.png", [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□☺☻←↑→↓]]) }	
	love.graphics.setFont(fonts.v360)
	
	buttons = Util.watch({"up", "down", "left", "right", "poke", "run", "menu"}, function(key) return love.keyboard.isDown(buttonMap[key]) end)
	buttonMap = {
		up    = "up",
		down  = "down",
		left  = "left",
		right = "right",
		poke  = "z",
		run   = "x",
		menu  = "return"
	}
	
	Player.loadResources()
	
	-- Other stuff
	clientPlayer = Player.new(nil)
	clientPlayer.me = castle.user.getMe()
	moveDir = Util.Point()
end

function client.update(dt)
	seconds = seconds + dt
	
	buttons:update()
	
	moveDir.x = 0
	moveDir.y = 0
	if buttons.down.up    then moveDir.y = -1 end
	if buttons.down.down  then moveDir.y =  1 end
	if buttons.down.left  then moveDir.x = -1 end
	if buttons.down.right then moveDir.x =  1 end
	Util.PointNormalize(moveDir)
	
	local running = buttons.down.run
	Player.move(clientPlayer, moveDir, running, dt)
	
	if client.connected then
		Player.clientUpdateData(clientPlayer, home)
	end
end

function client.draw()
	love.graphics.clear()
	
	love.graphics.push()
	-- love.graphics.translate(-clientPlayer.pos.x, -clientPlayer.pos.y)
	
	if client.connected then
		for _, player in pairs(share.players) do
			love.graphics.setColor(1, 1, 1)
			if player.id == client.id then -- this is you. draw you.
				Player.draw(clientPlayer, true)
			else
				Player.draw(player, false)
			end
		end
	else
		Player.draw(clientPlayer, true)
	end
	
	love.graphics.pop()
	
	if not client.connected then
		if seconds > 5 then
			love.graphics.print("Uh... something broke.", 0, 0)
			love.graphics.print("Maybe close the game and reopen?", 0, 8)
		else
			local msg = "*  * ** Connecting ** *  *"
			
			for i = 1, #msg do
				love.graphics.print(string.sub(msg, i, i), (SCREEN_WIDTH/2 - #msg*4) + (i * 8), SCREEN_HEIGHT/2 + Util.sine(seconds + (i / #msg), 5, 32))
			end
		end
	end
end
