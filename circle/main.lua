require('classes')
touchtimes = {}
love.window.setMode(1200, 650, {msaa=4, fullscreen=false, vsync=true})
function love.keypressed(key)
	if key == 'esc' then
		love.event.quit()
	elseif key == 'f' then
		love.window.setFullscreen(not love.window.getFullscreen())	
	elseif key == 'space' then
		if wells[1] then wells[1] = nil else wells[1] = {x=400,y=300,r=60} end
	end
end

function love.touchreleased(id, px, py)
	local pos = {x=px,y=py}
	local flag = false
	for i, well in ipairs(wells) do
		if well and distance(pos, well) < well.r then
			table.remove(wells, i)
			flag = true
		end
	end
	if not flag then
		table.insert(wells,{x=px,y=py,r=100})
	end
end

function love.update(dt)
	for i, well in ipairs(wells) do
		well.count = 0
		for d, dot in ipairs(dots) do
			if distance(dot, well) < RADIUS_MAX then
				well.count = well.count + 1
			end
		end
	end
	for i, dot in ipairs(dots) do update(dot, dt) end
	touches = love.touch.getTouches()
end

function love.draw()
	for i, dot in ipairs(dots) do
		if COLORS then love.graphics.setColor(HSL(dot.c, 255, 127)) else love.graphics.setColor(255, 255, 255) end
		love.graphics.circle('fill', dot.x, dot.y, 2)
	end
end

function love.load()
	for i = 1, num_dots do
		-- dots[i] = {x=screenMiddle().x,y=screenMiddle().y,vx=0,vy=0,a=0}
		dots[i] = {
			x=love.math.random(love.graphics.getWidth()),
			y=love.math.random(love.graphics.getWidth()),
			vx=0,
			vy=0,
			a=randomAngle(),
			c=0,
		}
	end
	for x = 1, math.floor(love.graphics.getWidth() / GRID_GAP) do
		grid[x] = {}
		for y = 1, math.floor(love.graphics.getHeight() / GRID_GAP) do
			grid[x][y] = 0
		end
	end
end
