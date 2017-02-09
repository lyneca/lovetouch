Particle = {
	x=0,
	y=0,
	angle=0,
	velocity=0,
	color={0,0,255}
}

function Particle:new(x, y)
	o = {x=x,y=y}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Particle:checkBounce()
	if not (0 < self.x and self.x < love.graphics.getWidth()) then
		if self.x < 0 then self.x = -1 * self.x end
		if self.x > love.graphics.getWidth() then self.x = 2 * love.graphics.getWidth() - self.x end
		self.vx = -1 * self.vx
		self.a = self.a + math.pi
	end
	if not (0 < self.y and self.y < love.graphics.getHeight()) then
		if self.y < 0 then self.y = -1 * self.y end
		if self.y > love.graphics.getHeight() then self.y = 2 * love.graphics.getHeight() - self.y end
		self.vy = -1 * self.vy
		self.a = self.a + math.pi
	end
end

function Particle:addVelocity(a, v)
	c = polToCart(a, v)
	self.vx = self.vx + c.x
	self.vy = self.vy + c.y
end

function Particle:distanceTo(o)
	return distance(self, o)	
end

function Particle:update(dt)

end

function Particle:draw()
	love.graphics.setColor(HSL(unpack(self.color)))
	love.graphics.circle('fill', self.x, self.y, 2)
end