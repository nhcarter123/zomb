-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function sign(n) return n>0 and 1 or n<0 and -1 or 0 end

-- Returns the distance between two points.
function dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

-- Returns the angle between two vectors assuming the same origin.
function angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function lengthDirX(dist, dir) return dist * math.cos(dir) end
function lengthDirY(dist, dir) return dist * math.sin(dir) end

-- Linear interpolation between two numbers.
function lerp(a,b,t) return (1-t)*a + t*b end

-- Clamps a number to within a certain range.
function clamp(low, n, high) return math.min(math.max(low, n), high) end

function toRad(ang) return ang * math.pi / 180 end
function toDeg(ang) return 180 * ang / math.pi end

function round(num)
    return math.floor(num+0.5)
end

function roundDecimal(v, p)
    -- figure out scaling factor for number of decimal points, or 0 if 'p' not supplied
    local scale = math.pow(10, p or 0);
    -- calculate result ignoring sign
    local res = math.floor(math.abs(v) * scale + 0.5) / scale;
    -- if 'v' was negative return value should be too
    if v < 0 then
        res = -res;
    end;
    -- return rounded value
    return res;
end;

function angleDiff(a1, a2)
    local result = a1 - a2
    return (result + 180) % 360 - 180
end

function weightSort(object1, object2)
    return object1.weight < object2.weight
end