Particle = {
	x = 0,
	y = 0,
	vx = 0,
	vy = 0,
	angle = 0,
	velocity = 0,
	color = {0,0,255},
	in_well = false,
	friction_free = config.particle.friction_free,
	friction_held = config.particle.friction_held,
	repulsion_radius = config.particle.repulsion_radius,
	repulsion_amount = config.particle.repulsion_amount,
	connections = config.particle.connections,
	connection_radius = config.particle.connection_radius,
}

function Particle:new(x, y)
	o = {x=x,y=y}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Particle:checkBounce()
	if self.x < 0 then
        self.x = -1 * self.x
        self.angle = rad(180) - self.angle
    end
	if self.x > love.graphics.getWidth() then
        self.x = 2 * love.graphics.getWidth() - self.x
       	self.angle = rad(180) - self.angle
    end
	if self.y < 0 then
        self.y = -1 * self.y
        self.angle = -self.angle
    end
	if self.y > love.graphics.getHeight() then
        self.y = 2 * love.graphics.getHeight() - self.y
        self.angle = -self.angle
    end
end

function Particle:addVelocity(a, v)
	new = vectorAdd(self.angle, self.velocity, a, v)
	self.velocity = new.m
	self.angle = new.d
end

function Particle:distanceTo(o)
	return distance(self, o)	
end

function Particle:angleTo(o)
	return angle(self, o)
end

function Particle:preUpdate(dt)
	self.in_well = false
end

function Particle:checkCollision()
	for i, p in ipairs(particles) do
		if self:distanceTo(p) < self.repulsion_radius and not (self.gx == p.gx and self.gy == p.gy) then
			self:addVelocity(self:angleTo(p) - rad(180), self.repulsion_amount)
		end
	end
end

function Particle:update(dt)
	if config.collide then self:checkCollision() end
	if not self.in_well then
		if config.grid.on then
			self:addVelocity(
				self:angleTo(
					{
						x = (self.gx + 1/2) * math.floor(love.graphics.getWidth() / config.grid.x),
						y = (self.gy + 1/2) * math.floor(love.graphics.getHeight() / config.grid.y)
					}
				),
				self:distanceTo(
					{
						x = (self.gx + 1/2) * math.floor(love.graphics.getWidth() / config.grid.x),
						y = (self.gy + 1/2) * math.floor(love.graphics.getHeight() / config.grid.y)
					}
				) / 100
			)
		end
		if config.random_particle_movement then
			self:addVelocity(rad(random(0, 360) - 180), 10)
		end
		if config.gravity then
			self:addVelocity(rad(90), 10)
		end
	end
	self.velocity = self.velocity * 0.98
	vel = polToCart(self.angle, self.velocity)
	self.x = self.x + vel.x * dt
	self.y = self.y + vel.y * dt
	self:checkBounce()
	-- self.color = {map(self.velocity,0,800,170,255),255,127}
	self.color = {map(self.velocity,0,700,0,255),255,127}
end

function Particle:draw()
	love.graphics.setColor(HSL(unpack(self.color)))
	love.graphics.circle('fill', self.x, self.y, 5)
	if self.connections then
		for i, p in ipairs(particles) do
			if self:distanceTo(p) < self.connection_radius and not (self.gx == p.gx and self.gy == p.gy) then
				love.graphics.line(self.x, self.y, p.x, p.y)
			end
		end
	end
end