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
end

function server.disconnect(id) -- Called on disconnect from client with `id`
	print("goodbye, " .. id .. "!")
end

function server.receive(id, ...) -- Called when client with `id` does `client.send(...)`
end

-- Main loop

function server.load()
	share.boxPos = Util.Point()
end

function server.update(dt)
	local dx = 0
	local dy = 0
	
	for id, home in pairs(server.homes) do
		dx = dx + home.move.x
		dy = dy + home.move.y
	end
	
	share.boxPos.x = share.boxPos.x + dx * dt
	share.boxPos.y = share.boxPos.y + dy * dt
end
