local Player = {}

Player.FaceSize = 12
Player.Speed = 64
Player.SpeedRun = 96

function Player.loadResources()
	Player.Image = love.graphics.newImage("resources/player.png")
	Player.ImageSize = Util.Size(Player.Image:getDimensions())
end

function Player.new(id)
	local p = {}
	
	p.id = id or false
	
	p.me = false
	p.photo = false
	
	p.pos = Util.Point()
	
	return p
end

-- Main Loop

function Player.draw(p, isClient)
	love.graphics.push()
	love.graphics.translate(p.pos.x, p.pos.y)
	
	if p.me then
		if not p.photo then
			p.photo = true
			network.async(function()
				p.photo = love.graphics.newImage(p.me.photoUrl)
			end)
		end
	end
	
	if isClient then
		love.graphics.setColor(0.5, 0.75, 1)
	else
		love.graphics.setColor(1, 1, 1)
	end
	love.graphics.draw(Player.Image, 0, 0, 0, 1, 1, Player.ImageSize.width / 2, Player.ImageSize.height)
	
	if p.photo and p.photo ~= true then
		love.graphics.draw(p.photo, -Player.FaceSize/2, 2 - Player.ImageSize.height, 0, Player.FaceSize / p.photo:getWidth(), Player.FaceSize / p.photo:getWidth())
	end
	
	love.graphics.pop()
end

function Player.move(p, moveDir, running, dt)
	Util.PointNormalize(moveDir)
	
	p.pos.x = p.pos.x + moveDir.x * (running and Player.SpeedRun or Player.Speed) * dt
	p.pos.y = p.pos.y + moveDir.y * (running and Player.SpeedRun or Player.Speed) * dt
end

-- Data

function Player.clientSetUpData(p, home)
	home.pos = Util.point()
end

function Player.clientUpdateData(p, home)
	home.pos.x = p.x
	home.pos.y = p.y
end

return Player
