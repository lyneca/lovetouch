Well = {
	x=0,
	y=0,
	radius=60,
	band_gap=20,
	collection_radius=100,
	color={255, 255, 255},
}

function Well:new(x, y, r, b, cr, c)
	o = {x=x,y=y,radius=r,band_gap=b,inner_radius=r-b,collection_radius=cr,color=c}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Well:update(dt)
	for _, p in ipairs(particles) do
		if self.distanceTo(p) < self.inner_radius then
			self.applyInner(p)
		elseif self.self.distanceTo(p) < self.radius then
			self.applyBand(p)
		elseif self.distanceTo(p) < self.collection_radius then
			self.applyOuter(p)
		else
			
		end
	end
end

function Well:distanceTo(p)
	return distance(self, p)	
end

function Well:applyInner(p)
	
end

function Well:applyBand(p)

end

function Well:applyOuter(p)

end