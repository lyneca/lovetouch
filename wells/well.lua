Well = {
	x=0,
	y=0,
	radius=100,
	band_gap=20,
	collection_radius=150,
	strength=0.25,
	orbit_velocity = 10,
	color={0, 0, 255},
}

function Well:new(x, y, r, b, cr, c, s, ov)
	o = {
		x = x,
        y = y,
        radius = r or Well.radius,
        band_gap = b or Well.band_gap,
        inner_radius = (r or Well.radius) - (b or Well.band_gap),
        collection_radius = cr or Well.collection_radius,
        strength = s or Well.strength,
        orbit_velocity = ov or Well.orbit_velocity,
        color = c or Well.color,
    }
	setmetatable(o, self)
	self.__index = self
	return o
end

function Well:update(dt)
	if self.touchid and love.touch.getTouches()[self.touchid] ~= nil then
		self.x, self.y = love.touch.getPosition(self.touchid)
	end
	for _, p in ipairs(particles) do
		p.in_well = true
		if self:distanceTo(p) < self.inner_radius then
			self:applyInner(p)
		elseif self:distanceTo(p) < self.radius then
			self:applyBand(p)
		elseif self:distanceTo(p) < self.collection_radius then
			self:applyOuter(p)
		else
			p.in_well = false
		end
	end
end

function Well:distanceTo(p)
	return distance(self, p)
end

function Well:applyInner(p)
	p:addVelocity(angle(p, self) + rad(180), (self.inner_radius - self:distanceTo(p)) / (self.strength / 8))
end

function Well:applyBand(p)
	if angle(p, self) + rad(90) - p.angle > 0 then
		p.angle = p.angle + rad(1)
	elseif angle(p, self) + rad(90) - p.angle < 0 then
		p.angle = p.angle - rad(1)
	end
	p:addVelocity(angle(p, self) + rad(90), self.orbit_velocity)
end

function Well:applyOuter(p)
	p:addVelocity(angle(p, self), (self:distanceTo(p) - self.radius) / self.strength)
end