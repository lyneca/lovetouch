require('config')
wells = {}
particles = {}

require('utils')
require('particle')
require('well')

function love.keypressed(key)
	if key == 'esc' then
		love.event.quit()
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())	
		particles = {}
		makeParticles()
	end
end

function love.load()
	print(love.joystick.getJoysticks())
	love.window.setMode(config.screen_width, config.screen_height, {msaa=2})
	makeParticles()
end

function love.touchpressed(id, px, py)
	w = Well:new(px, py, 80, 10, 0, 120, nil, 0.25)
	w.touchid = id
	table.insert(wells, w)
	w = Well:new(px, py, 160, 10, 120, 200, nil, 0.25, -10)
	w.touchid = id
	table.insert(wells, w)
	w = Well:new(px, py, 240, 10, 200, 320, nil, 0.25)
	w.touchid = id
	table.insert(wells, w)
end

function love.touchreleased(id)
	for i, well in ipairs(wells) do
		if w.touchid == id then
			table.remove(wells, i)
		end
	end
end

function makeParticles()
	for i = 1, config.num_particles do
		p = Particle:new(
			random(0, love.graphics.getWidth()),
			random(0, love.graphics.getHeight())
		)
		p.gx = (i-1) % (config.grid.x)
		p.gy = math.floor((i-1) / (config.grid.x))
		table.insert(
			particles, p
		)
	end
	-- table.insert(wells, Well:new(300, 400))
end

function love.update(dt)
	for _, particle in ipairs(particles) do
		particle:preUpdate(dt)	
	end
	for _, well in ipairs(wells) do
		well:update(dt)
	end
	for _, particle in ipairs(particles) do
		particle:update(dt)	
	end
end

function love.draw()
	for _, particle in ipairs(particles) do
		particle:draw()
	end
end
