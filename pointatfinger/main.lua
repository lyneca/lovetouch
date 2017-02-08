angle = 0

function pointAt(target)
	return math.pi * 5/2 - math.atan2(target.x - 400, target.y - 300)
end

function cart(pos, angle, length)
	return {
		x = pos.x + length * math.cos(angle),
		y = pos.y + length * math.sin(angle),
	}
end

function love.load()

end

function love.update(dt)
	touches = love.touch.getTouches()
	for id, _ in ipairs(touches) do
		t = {}
		t.x, t.y = love.touch.getPosition(touches[id])
		angle = pointAt(t)
	end
end

function love.draw()
	love.graphics.circle('fill', 400, 300, 3)
	l = cart({x=400,y=300},angle,10)
	love.graphics.line(400, 300, l.x, l.y)
end