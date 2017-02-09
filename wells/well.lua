Well = {
	x=0,
	y=0,
	radius=100,
	band_gap=20,
	inner_collection_radius=60,
	collection_radius=150,
	strength=0.25,
	orbit_velocity = 10,
	color={0, 0, 255},
}

function Well:new(x, y, r, b, icr, cr, c, s, ov)
	o = {
		x = x,
        y = y,
        radius = r or Well.radius,
        band_gap = b or Well.band_gap,
        inner_radius = (r or Well.radius) - (b or Well.band_gap),
        inner_collection_radius = icr or Well.inner_collection_radius,
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
	if self.touchid then
		if pcall(love.touch.getPosition, self.touchid) then
			self.x, self.y = love.touch.getPosition(self.touchid)
		else
			return
		end
	end
	for _, p in ipairs(particles) do
		p.in_well = true
		if self:distanceTo(p) < self.collection_radius then
			self:applyAll(p)
		end
		if self:distanceTo(p) < self.inner_collection_radius then
			self:applyCenter(p)
		elseif self:distanceTo(p) < self.inner_radius then
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

function Well:applyAll(p)
	-- p.color = {0,255-map(self:distanceTo(p),0,self.collection_radius,0,128)*2,128}
end

function Well:applyCenter(p)

end

function Well:applyInner(p)
	p:addVelocity(angle(p, self) + rad(180), cap(self.inner_radius - self:distanceTo(p), 4) / (self.strength / 8))
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
	p:addVelocity(angle(p, self), cap(self:distanceTo(p) - self.radius, 4) / self.strength)
end