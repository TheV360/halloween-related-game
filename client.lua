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
	clientPlayer.id = client.id
	Player.clientSetUpData(clientPlayer, client.home)
	
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
	
	Camera = require("game/camera")
	denver = require("lib/denver")
	
	Player.loadResources()
	
	-- Other stuff
	clientPlayer = Player(nil)
	clientPlayer.me = castle.user.getMe()
	camera = Camera(clientPlayer)
	
	pianoSound = denver.get{waveform = "triangle"}
	pianoSound:setLooping(true)
	
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
	
	local running = buttons.down.run
	clientPlayer:move(moveDir, running, dt)
	
	camera:update()
	
	if buttons.down.poke then pianoSound:setPitch((clientPlayer.pos.x + 32) / 64) end
	if buttons.press.poke then
		pianoSound:play()
	end
	if buttons.release.poke then
		pianoSound:stop()
	end
	
	if client.connected then
		clientPlayer.clientUpdateData(client.home)
	end
end

function client.draw()
	love.graphics.clear()
	
	love.graphics.push()
	love.graphics.translate(SCREEN_WIDTH/2 - camera.pos.x, SCREEN_HEIGHT/2 - camera.pos.y)
	
	if client.connected then
		for _, player in pairs(share.players) do
			if player.id ~= client.id then
				player:draw(false)
			end
		end
		
		-- table.sort(YSort,)
		
		-- for i = 1, #YSort do
		-- end
	end
	
	clientPlayer:draw(true)
	
	love.graphics.print(clientPlayer.pos.x, 0, 0)
	love.graphics.print(clientPlayer.pos.y, 0, 8)
	
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
