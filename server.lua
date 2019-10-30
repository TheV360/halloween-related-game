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
	share.players[id] = Player(id)
end

function server.disconnect(id) -- Called on disconnect from client with `id`
	print("goodbye, " .. id .. "!")
	share.players[id] = nil
end

function server.receive(id, ...) -- Called when client with `id` does `client.send(...)`
end

-- Main loop

function server.load()
	share.players = {}
end

function server.update(dt)
	for id, p in pairs(share.players) do
		p:serverUpdateData(homes[id])
	end
end

-- Server Functions
