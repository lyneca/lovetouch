config = {
	num_particles = 200,
	screen_height = 600,
	screen_width = 1000,
	grid = {
		on = false,
		x = 25,
		y = 15
	},
	random_particle_movement = true,
	collide = true,
	gravity = false,
	particle = {
		friction_free = 0.7,
		friction_held = 0.8,
		repulsion_radius = 10,
		repulsion_amount = 10,
		connections = true,
		connection_radius = 50,
	},
	well = {}
}
if config.grid.on then config.num_particles = config.grid.x * config.grid.y end