function cos(x) return math.cos(x) end
function sin(x) return math.sin(x) end
function atan2(x, y) return math.atan2(x, y) end
function rad(a) return math.rad(a) end
function deg(a) return math.deg(a) end
function sqrt(a) return math.sqrt(a) end
function pow(a, b) return math.pow(a, b) end
function abs(a) return math.abs(a) end

function random(a, b)
	return love.math.random(a, b)
end

function cap(a, b)
	if a > b then return b else return a end
end

function pyth(a, b)
	return sqrt(pow(a, 2) + pow(b, 2))
end

function distance(a, b)
	return pyth(b.x - a.x, b.y - a.y)
end

function midpoint(a, b)
	return {x = (a.x + b.x) / 2, y = (a.y + b.y) / 2}
end

function cartToPol(dx, dy)
	return {
		d = math.pi * 5/2 - math.atan2(dx, dy),
		m = pyth(dx, dy)
	}
end

function angle(a, b)
	return cartToPol(b.x - a.x, b.y - a.y).d
end

function vectorAdd(d1, m1, d2, m2)
	c1 = polToCart(d1, m1)
	c2 = polToCart(d2, m2)
	return cartToPol(c1.x + c2.x, c1.y + c2.y)
end

function polToCart(a, r)
	return {
		x = r * cos(a),
		y = r * sin(a)
	}
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

function map(v, l, h, ol, oh)
	if v >= h then return oh 
	elseif v <= ol then return ol
	else return (v-l)/(h-l)*(oh-ol)+ol
	end
end