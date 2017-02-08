num_dots = 7

dots = {}

for i = 1, num_dots do
	dots[i] = {x=0,y=0,vx=0,vy=0}
end

love.window.setMode(1200, 650, {msaa=4, fullscreen=false, vsync=true})

f1 = {x=love.graphics.getWidth() / 2 - 100, y = love.graphics.getHeight() / 2}
f2 = {x=love.graphics.getWidth() / 2 + 100, y = love.graphics.getHeight() / 2}

t = 0

function love.load()

end

function love.keypressed(key)
	if key == 'esc' then
		love.event.quit()
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())	
	end
end

function distance(a, b)
	return math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2))
end

function midpoint(a, b)
	return {x = (a.x + b.x) / 2, y = (a.y + b.y) / 2}
end

function getLemniscateXY(a, t)
	return {
		x = a * math.cos(t) / (1 + math.pow(math.sin(t), 2)),
		y = a * math.sin(t) * math.cos(t) / (1 + math.pow(math.sin(t), 2))
	}
end

function love.update(dt)
	touches = love.touch.getTouches()
	t = t + 4 * dt
	i = 0
	for _, id in ipairs(touches) do 
		i = i + 1
	end
	if i == 1 then
		x, y = love.touch.getPosition(touches[1])
		dots[1].x = x + math.cos(2*math.pi - t) * 100
		dots[1].y = y + math.sin(2*math.pi - t) * 100
	else
		if i == 2 then
			f1.x, f1.y = love.touch.getPosition(touches[1])
			f2.x, f2.y = love.touch.getPosition(touches[2])
		end
		focal_distance = distance(f1, f2)
		center = midpoint(f1, f2)
		temp = getLemniscateXY(focal_distance, t)
		temp.x = temp.x + center.x
		temp.y = temp.y + center.y
		focus_angle = math.atan2(f1.x - f2.x, f1.y - f2.y)
		dot_angle = 2 * math.pi - (math.atan2(temp.x - center.x, temp.y - center.y) + focus_angle)
		dot_distance = distance(temp, center)
		dots[1].x = center.x + dot_distance * math.cos(dot_angle)
		dots[1].y = center.y + dot_distance * math.sin(dot_angle)
	end
	if t >= math.pi * 2 then t = 0 end
	for i = 2, #dots do
		dots[i].vx = dots[i].vx + (dots[i-1].x - dots[i].x) / 128
		dots[i].vy = dots[i].vy + (dots[i-1].y - dots[i].y) / 128
		dots[i].vx = dots[i].vx * 0.9
		dots[i].vy = dots[i].vy * 0.9
		dots[i].x = dots[i].x + dots[i].vx
		dots[i].y = dots[i].y + dots[i].vy
	end
end



function love.draw()
	love.graphics.circle('fill', f1.x, f1.y, 2)
	love.graphics.circle('fill', f2.x, f2.y, 2)
	for i = 2, #dots do
		dot = dots[i]
		love.graphics.circle('fill', dot.x, dot.y, 5)
	end
end