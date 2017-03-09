local utf8 = require('utf8')
num_dots = 300

dots = {}

grid = {}

FRICTION_FREE = 0.9
FRICTION_HELD = 0.96
MOVE_SPEED = 1
RANDOM_MOVE_AMOUNT = 15

RADIUS_PICKUP = 250
RADIUS_MAX = 200
RADIUS_MIN = 180

INNER_RADIUS_PICKUP = 145

INNER_RADIUS_MAX = 120 

INNER_RADIUS_MIN = 100

ORBIT_SPEED = 20

SPEED_LIMIT = 800

GRID_GAP = 20

love.window.setMode(1200, 650, {fullscreen=false})

paused = false

draw_command_input = false
command_input = ""

function love.textinput(t)
  if draw_command_input then
    if t ~= ':' then
      command_input = command_input .. t
    end
  end
  if t == ':' then
    paused = false
    command_input = ""
    draw_command_input = true
  end
end

function love.keypressed(key)
	if key == 'escape' then
    if draw_command_input then
      command_input = ""
      draw_command_input = false
    else
		  love.event.quit()
    end
  elseif key == 'backspace' then
    local byteoffset = utf8.offset(command_input, -1)
    if byteoffset then
      command_input = string.sub(command_input, 1, byteoffset - 1)
    end
	elseif key == 'f' and not draw_command_input then
		love.window.setFullscreen(not love.window.getFullscreen())	
	elseif key == 'space' and not draw_command_input then
		paused = not paused
  elseif key == 'return' and draw_command_input then
    execute(command_input)
    draw_command_input = false
  end
end

function execute(text)
  loadstring(text)()
end

function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

function distance(a, b)
	return math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2))
end

function screenMiddle()
	return {x=love.graphics.getWidth() / 2, y=love.graphics.getHeight() / 2}
end

function midpoint(a, b)
	return {x = (a.x + b.x) / 2, y = (a.y + b.y) / 2}
end

function randomAngle()
	return love.math.random() * math.pi * 2
end

function love.load()
  love.keyboard.setKeyRepeat(true)
	for i = 1, num_dots do
		-- dots[i] = {x=screenMiddle().x,y=screenMiddle().y,vx=0,vy=0,a=0}
		dots[i] = {
			x=love.math.random(0, love.graphics.getWidth()),
			y=love.math.random(0, love.graphics.getHeight()),
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

function getNumTouches()
	i = 0
	for _, _ in ipairs(love.touch.getTouches()) do
		i = i + 1
	end 
	return i
end

function getAngle(a, b)
	return math.pi * 5/2 - math.atan2(b.x - a.x, b.y, a.y)
end

function addVelocity(dot, vel)
	dot.vx = dot.vx + math.cos(dot.a) * vel
	dot.vy = dot.vy + math.sin(dot.a) * vel
end

function pointAt(dot, target)
	dot.a = math.pi * 5/2 - math.atan2(target.x - dot.x, target.y - dot.y)
end

function bounce(dot)
	if not (0 < dot.x and dot.x < love.graphics.getWidth()) then
		if dot.x < 0 then dot.x = -1 * dot.x end
		if dot.x > love.graphics.getWidth() then dot.x = 2 * love.graphics.getWidth() - dot.x end
		dot.vx = -1 * dot.vx
		dot.a = dot.a + math.pi
	end
	if not (0 < dot.y and dot.y < love.graphics.getHeight()) then
		if dot.y < 0 then dot.y = -1 * dot.y end
		if dot.y > love.graphics.getHeight() then dot.y = 2 * love.graphics.getHeight() - dot.y end
		dot.vy = -1 * dot.vy
		dot.a = dot.a + math.pi
	end
end

function getVelocity(dot) 
	return math.sqrt(math.pow(dot.vx, 2) + math.pow(dot.vy, 2))
end

function turnRandom(dot)
	if love.math.random(100) == 1 then dot.a = dot.a + randomAngle() end 
	if dot.a > math.pi * 2 then dot.a = dot.a - math.pi * 2 end
	addVelocity(dot, love.math.random(RANDOM_MOVE_AMOUNT))
end

function applyFriction(dot, f)
	dot.vx = dot.vx * f
	dot.vy = dot.vy * f
end

function map(v, l, h, ol, oh)
	return (v-l)/(h-l)*(oh-ol)+ol
end

function update(dot, dt)
	if getNumTouches() > 0 then
		smallest_distance = math.huge
		flag = false
		thistouch = 0
		touches = love.touch.getTouches()
		for _, id in ipairs(touches) do
			pos = {}
			pos.x, pos.y = love.touch.getPosition(id)
			dist = distance(dot, pos)
			if dist < smallest_distance and dist < RADIUS_PICKUP then
				flag = true
				smallest_distance = dist
				target = pos
				thistouch = id
			end
		end
		if flag then
			if distance(target, dot) > RADIUS_MAX then
				pointAt(dot, target)
				addVelocity(dot, distance(dot, target) / 4)
			elseif RADIUS_MIN < distance(target, dot) and distance(target, dot) < RADIUS_MAX then 
				pointAt(dot, target)
				dot.a = dot.a + math.pi / 2
				addVelocity(dot, ORBIT_SPEED)
			elseif INNER_RADIUS_PICKUP < distance(target, dot) and distance(target, dot) < RADIUS_MIN then
				pointAt(dot, target)
				dot.a = dot.a + math.pi
				addVelocity(dot, (RADIUS_MIN - distance(dot, target)) / 1)
			elseif INNER_RADIUS_MAX < distance(target, dot) and distance(target, dot) < INNER_RADIUS_PICKUP then
				pointAt(dot, target)
				addVelocity(dot, (RADIUS_MIN - distance(dot, target)) / 1)
			else
				pointAt(dot, target)
				dot.a = dot.a - math.pi / 2
				addVelocity(dot, ORBIT_SPEED)
			end
			applyFriction(dot, FRICTION_HELD)	
		else
			applyFriction(dot, FRICTION_FREE)
			-- dot.vy = dot.vy + 1001 * dt
		end
	else
		applyFriction(dot, FRICTION_FREE)
		-- dot.vy = dot.vy + 1001 * dt
	end
	turnRandom(dot)
	dot.x = dot.x + dot.vx * dt
	dot.y = dot.y + dot.vy * dt
	bounce(dot)
	dot.c = map(getVelocity(dot), 0, SPEED_LIMIT, 0, 255)
	dot.c = (dot.c + 120) % 255
end

function love.update(dt)
	if paused then
		for i, dot in ipairs(dots) do update(dot, dt) end
		touches = love.touch.getTouches()
	end
end

function love.draw()
	-- love.graphics.print(dots[1].a)
	-- love.graphics.print(dots[1].c .. ', ' .. getVelocity(dots[1]))
	-- for x, i in ipairs(grid) do
	-- 	for y, b in ipairs(i) do
	-- 		love.graphics.setColor(HSL(0, 0, b))
	-- 		love.graphics.circle('fill', GRID_GAP * (1 + x), GRID_GAP * (1 + y), 3)
	-- 	end
	-- end
	for i, dot in ipairs(dots) do
		love.graphics.setColor(HSL(dot.c, 255, 127))
		love.graphics.circle('fill', dot.x, dot.y, 5)
		-- pointIndicator = cart(dot, dot.a, 10)
		-- love.graphics.line(dot.x, dot.y, pointIndicator.x, pointIndicator.y)
	end
  if draw_command_input then
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(':' .. command_input)
  end
end
