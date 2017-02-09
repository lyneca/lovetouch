require('utils')
require('particle')
require('well')

wells = {}
particles = {}

config = {
	num_particles = 100,
	screen_width = 800,
	screen_height = 600
}

function love.keypressed(key)
	if key == 'esc' then
		love.event.quit()
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())	
	end
end

function love.load()
	love.window.setMode(config.screen_width, config.screen_height, {msaa=2})
	makeParticles()
end

function love.touchpressed(id, px, py)
	local pos = {x=px,y=py}
	w = Well:new(px, py)
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
		table.insert(
			particles, Particle:new(
				random(0, config.screen_width),
				random(0, config.screen_height)
			)
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
