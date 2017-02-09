require('utils')
require('particle')
require('well')

wells = {}
particles = {}

config = {
	num_particles = 300,
	screen_width = 800,
	screen_height = 600
}

function love.load()
	love.window.setMode(config.screen_width, config.screen_height, {msaa=16})
	makeParticles()
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
end

function love.update(dt)
	for _, particle in ipairs(particles) do
		particle:update()	
	end
end

function love.draw()
	for _, particle in ipairs(particles) do
		particle:draw()
	end
end
