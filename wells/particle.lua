Particle = {
	x=0,
	y=0,
	vx=0,
	vy=0,
	angle=0,
	velocity=0,
	color={0,0,255},
	in_well=false,
	friction_free=0.99,
	friction_held = 0.9
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
        self.angle = -self.angle
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

function Particle:preUpdate(dt)
	self.in_well = false
end

function Particle:update(dt)
	vel = polToCart(self.angle, self.velocity)
	self.x = self.x + vel.x * dt
	self.y = self.y + vel.y * dt
	self.velocity = self.velocity * 0.98
	if not self.in_well then
		self:addVelocity(rad(random(0, 360) - 180), 5)
	end
	self:checkBounce()
end

function Particle:draw()
	love.graphics.setColor(HSL(unpack(self.color)))
	love.graphics.circle('fill', self.x, self.y, 2)
end