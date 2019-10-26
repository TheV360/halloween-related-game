require "common"

--- SERVER

local server = cs.server

if USE_CASTLE_CONFIG then
	server.useCastleConfig()
else
	server.enabled = true
	server.start("22122")
end

local share = server.share
local homes = server.homes

-- Events

function server.connect(id) -- Called on connect from client with `id`
	print("hello, " .. id .. "!")
	share.players[id] = newPlayer(id)
end

function server.disconnect(id) -- Called on disconnect from client with `id`
	print("goodbye, " .. id .. "!")
	share.players[id] = nil
end

function server.receive(id, ...) -- Called when client with `id` does `client.send(...)`
end

-- Main loop

function server.load()
	-- share.boxPos = Util.Point()
	
	share.players = {}
end

function server.update(dt)
	for _, player in pairs(share.players) do
		local id = player.id
		
		if not player.me then
			player.me = homes[id].me
		end
		
		if homes[id].ready then
			player.x = player.x + homes[id].move.x * PLAYER_SPEED * dt
			player.y = player.y + homes[id].move.y * PLAYER_SPEED * dt
		end
	end
end

-- Server Functions

function newPlayer(id)
	local p = {id = id}
	p.photo = false
	
	p.x = 0
	p.y = 0
	
	return p
end
