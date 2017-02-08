num_dots = 100

dots = {}

grid = {}

wells = {}

FRICTION_FREE = 0.99
FRICTION_HELD = 0.9
MOVE_SPEED = 1
RANDOM_MOVE_AMOUNT = 1

-- RADIUS_PICKUP = 400
RADIUS_MAX = 60
RADIUS_PICKUP = RADIUS_MAX * 2
RADIUS_MIN = RADIUS_MAX - 10

ORBIT_SPEED = 40

SPEED_LIMIT = 700
COLORS = false

GRID_GAP = 20

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

function cart(pos, angle, length)
	return {
		x = pos.x + length * math.cos(angle),
		y = pos.y + length * math.sin(angle),
	}
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

function isInWell(dot)
	for i, well in ipairs(wells) do
		dist = distance(dot, well)
		if dist < well.r then return true end
	end
	return false
end

function update(dot, dt)
	smallest_distance = math.huge
	flag = false
	-- if TOUCH then
	-- 	touches = love.touch.getTouches()
	-- 	for _, id in ipairs(touches) do
	-- 		pos = {}
	-- 		pos.x, pos.y = love.touch.getPosition(id)
	-- 		dist = distance(dot, pos)
	-- 		if dist and dist < RADIUS_PICKUP then
	-- 			flag = true
	-- 			smallest_distance = dist
	-- 			target = pos
	-- 		end
	-- 	end
	-- end
	for _, well in ipairs(wells) do
		if well then
			dist = distance(dot, well)
			if dist and dist < smallest_distance and dist < well.r * 2 then
				flag = true
				smallest_distance = dist
				target = well
			end
		end
	end
	if flag then
		if distance(target, dot) > target.r then
			pointAt(dot, target)
			addVelocity(dot, distance(dot, target) / 1)
		elseif distance(target, dot) < target.r - 10 then
			pointAt(dot, target)
			dot.a = dot.a + math.pi
			addVelocity(dot, (target.r - 10 - distance(dot, target)) * 8)
		else
			addVelocity(dot, ORBIT_SPEED)
			pointAt(dot, target)
			dot.a = dot.a + math.pi / 2
		end
		applyFriction(dot, FRICTION_HELD)	
	else
		applyFriction(dot, FRICTION_FREE)
		turnRandom(dot)	
	end
	dot.x = dot.x + dot.vx * dt
	dot.y = dot.y + dot.vy * dt
	bounce(dot)
	dot.c = map(getVelocity(dot), 0, SPEED_LIMIT, 0, 255)
	dot.c = (dot.c + 80) % 255
end

