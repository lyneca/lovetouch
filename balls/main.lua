require("utils")

Ball = {
	x = 0,
	y = 0,
	vx = 0,
	vy = 0,
	c = {255, 255, 255},
	r = 100
}

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

FRICTION = 0.98

balls = {}

function Ball:new(i, x, y, r, c)
	o = {i=i,x=x,y=y,r=r,c=c}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Ball:addForce(a, v)
	self.vx = self.vx + v * cos(a)
	self.vy = self.vy + v * sin(a)
end

function Ball:angleTo(o)
	return angle(self, o)
end

function Ball:distanceTo(o)
	return distance(self, o)
end

function checkBounce(o)
	if o.x - o.r <= 0 then
		o.vx = o.vx * -1
		-- o.x = o.x * -1
	end
	if o.y - o.r <= 0 then
		o.vy = o.vy * -1
		-- o.y = o.y * -1
	end
	if o.x + o.r >= SCREEN_WIDTH then
		o.vx = o.vx * -1
		-- o.x = 2 * SCREEN_WIDTH - o.x
	end
	if o.y + o.r >= SCREEN_HEIGHT then
		o.vy = o.vy * -1
		-- o.y = 2 * SCREEN_HEIGHT - o.y
	end
end

function Ball:update(dt)
	self.vx = self.vx * FRICTION
	self.vy = self.vy * FRICTION
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt
	for k, ball in ipairs(balls) do
		if ball.i ~= self.i and self:distanceTo(ball) <= self.r + ball.r then
			if pyth(ball.vx, ball.vy) == pyth(self.vx, self.vy) and pyth(self.vx, self.vy) == 0 then
				ball:addForce(self:angleTo(ball), 100)
				self:addForce(rad(180) - self:angleTo(ball), 100)
			else
				ball:addForce(self:angleTo(ball), pyth(self.vx, self.vy))
			end
		end
	end
	checkBounce(self)
end

function invert(c)
	return {
		255 - c[1],
		255 - c[2],
		255 - c[3]
	}
end

function Ball:draw()
	love.graphics.setColor(self.c)
	love.graphics.circle("fill", self.x, self.y, self.r)
	-- love.graphics.setColor(invert(self.c))
	-- love.graphics.print(self.x .. ', ' .. self.y, self.x, self.y - 20, r)
	-- love.graphics.print(self.vx .. ', ' .. self.vy, self.x, self.y + 20, r)
end

function rand(a, b)
	return love.math.random(a, b)
end

function love.load()
	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {msaa=8})
	for i=1,5 do
		table.insert(
			balls,
			Ball:new(
				i,
				rand(100, SCREEN_WIDTH - 100),
				rand(100, SCREEN_HEIGHT - 100),
				rand(50, 100),
				{
					rand(0, 255),
					rand(0, 255),
					rand(0, 255)
				}
			)
		)
	end
	-- table.insert(balls, Ball:new(1, 200, 300, 50, {200, 50, 50}))
	-- table.insert(balls, Ball:new(2, 600, 300, 100, {50, 50, 200}))
	-- table.insert(balls, Ball:new(3, 400, 200, 70, {50, 200, 50}))
	-- balls[1].vx = 500
	-- balls[2].vx = -500
end

function love.update(dt)
	for k, ball in ipairs(balls) do
		ball:update(dt)
	end
end

function love.draw()
	for k, ball in ipairs(balls) do
		ball:draw()
	end
end