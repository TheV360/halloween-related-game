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
		dx = dx + ((home and home.move and home.move.x) or 0)
		dy = dy + ((home and home.move and home.move.y) or 0)
	end
	
	share.boxPos.x = share.boxPos.x + dx * 15 * dt
	share.boxPos.y = share.boxPos.y + dy * 15 * dt
end
