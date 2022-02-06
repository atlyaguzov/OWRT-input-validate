
local ip = require "owrt_input_validate.ip"

local datatypes = {}

datatypes['or'] = function(v, ...)
	local i
	for i = 1, select('#', ...), 2 do
		local f = select(i, ...)
		local a = select(i+1, ...)
		if type(f) ~= "function" then
			if f == v then
				return true
			end
			i = i - 1
		elseif f(v, unpack(a)) then
			return true
		end
	end
	return false
end

datatypes['and'] = function(v, ...)
	local i
	for i = 1, select('#', ...), 2 do
		local f = select(i, ...)
		local a = select(i+1, ...)
		if type(f) ~= "function" then
			if f ~= v then
				return false
			end
			i = i - 1
		elseif not f(v, unpack(a)) then
			return false
		end
	end
	return true
end

function datatypes.neg(v, ...)
	return datatypes['or'](v:gsub("^%s*!%s*", ""), ...)
end

function datatypes.list(v, subvalidator, subargs)
	if type(subvalidator) ~= "function" then
		return false
	end
	local token
	for token in v:gmatch("%S+") do
		if not subvalidator(token, unpack(subargs)) then
			return false
		end
	end
	return true
end

function datatypes.bool(val)
	if val == "1" or val == "yes" or val == "on" or val == "true" then
		return true
	elseif val == "0" or val == "no" or val == "off" or val == "false" then
		return true
	elseif val == "" or val == nil then
		return true
	end

	return false
end

function datatypes.uinteger(val)
	local n = tonumber(val)
	if n ~= nil and math.floor(n) == n and n >= 0 then
		return true
	end

	return false
end

function datatypes.integer(val)
	local n = tonumber(val)
	if n ~= nil and math.floor(n) == n then
		return true
	end

	return false
end

function datatypes.ufloat(val)
	local n = tonumber(val)
	return ( n ~= nil and n >= 0 )
end

function datatypes.float(val)
	return ( tonumber(val) ~= nil )
end

function datatypes.ipaddr(val)
	return datatypes.ip4addr(val) or datatypes.ip6addr(val)
end

function datatypes.ip4addr(val)
	if val then
		return ip.IPv4(val) and true or false
	end

	return false
end

function datatypes.ip4prefix(val)
	val = tonumber(val)
	return ( val and val >= 0 and val <= 32 )
end

function datatypes.ip6addr(val)
	if val then
		return ip.IPv6(val) and true or false
	end

	return false
end

function datatypes.ip6prefix(val)
	val = tonumber(val)
	return ( val and val >= 0 and val <= 128 )
end

function datatypes.cidr(val)
	return datatypes.cidr4(val) or datatypes.cidr6(val)
end

function datatypes.cidr4(val)
	local ip, mask = val:match("^([^/]+)/([^/]+)$")

	return datatypes.ip4addr(ip) and datatypes.ip4prefix(mask)
end

function datatypes.cidr6(val)
	local ip, mask = val:match("^([^/]+)/([^/]+)$")

	return datatypes.ip6addr(ip) and datatypes.ip6prefix(mask)
end

function datatypes.ipnet4(val)
	local ip, mask = val:match("^([^/]+)/([^/]+)$")

	return datatypes.ip4addr(ip) and datatypes.ip4addr(mask)
end

function datatypes.ipnet6(val)
	local ip, mask = val:match("^([^/]+)/([^/]+)$")

	return datatypes.ip6addr(ip) and datatypes.ip6addr(mask)
end

function datatypes.ipmask(val)
	return datatypes.ipmask4(val) or datatypes.ipmask6(val)
end

function datatypes.ipmask4(val)
	return datatypes.cidr4(val) or datatypes.ipnet4(val) or datatypes.ip4addr(val)
end

function datatypes.ipmask6(val)
	return datatypes.cidr6(val) or datatypes.ipnet6(val) or datatypes.ip6addr(val)
end

function datatypes.ip6hostid(val)
	if val == "eui64" or val == "random" then
		return true
	else
		local addr = ip.IPv6(val)
		if addr and addr:prefix() == 128 and addr:lower("::1:0:0:0:0") then
			return true
		end
	end

	return false
end

function datatypes.port(val)
	val = tonumber(val)
	return ( val and val >= 0 and val <= 65535 )
end

function datatypes.portrange(val)
	local p1, p2 = val:match("^(%d+)%-(%d+)$")
	if p1 and p2 and datatypes.port(p1) and datatypes.port(p2) then
		return true
	else
		return datatypes.port(val)
	end
end

function datatypes.c(val)
	return ip.checkmac(val) and true or false
end

function datatypes.hostname(val, strict)
	if val and (#val < 254) and (
	   val:match("^[a-zA-Z_]+$") or
	   (val:match("^[a-zA-Z0-9_][a-zA-Z0-9_%-%.]*[a-zA-Z0-9]$") and
	    val:match("[^0-9%.]"))
	) then
		return (not strict or not val:match("^_"))
	end
	return false
end

function datatypes.host(val, ipv4only)
	return datatypes.hostname(val) or ((ipv4only == 1) and datatypes.ip4addr(val)) or ((not (ipv4only == 1)) and datatypes.ipaddr(val))
end

function datatypes.network(val)
	return datatypes.uciname(val) or datatypes.host(val)
end

function datatypes.hostport(val, ipv4only)
	local h, p = val:match("^([^:]+):([^:]+)$")
	return not not (h and p and datatypes.host(h, ipv4only) and datatypes.port(p))
end

function datatypes.ip4addrport(val, bracket)
	local h, p = val:match("^([^:]+):([^:]+)$")
	return (h and p and datatypes.ip4addr(h) and datatypes.port(p))
end

function datatypes.ip4addrport(val)
	local h, p = val:match("^([^:]+):([^:]+)$")
	return (h and p and datatypes.ip4addr(h) and datatypes.port(p))
end

function datatypes.ipaddrport(val, bracket)
	local h, p = val:match("^([^%[%]:]+):([^:]+)$")
	if (h and p and datatypes.ip4addr(h) and datatypes.port(p)) then
		return true
	elseif (bracket == 1) then
		h, p = val:match("^%[(.+)%]:([^:]+)$")
		if  (h and p and datatypes.ip6addr(h) and datatypes.port(p)) then
			return true
		end
	end
	h, p = val:match("^([^%[%]]+):([^:]+)$")
	return (h and p and datatypes.ip6addr(h) and datatypes.port(p))
end

function datatypes.wpakey(val)
	if #val == 64 then
		return (val:match("^[a-fA-F0-9]+$") ~= nil)
	else
		return (#val >= 8) and (#val <= 63)
	end
end

function datatypes.wepkey(val)
	if val:sub(1, 2) == "s:" then
		val = val:sub(3)
	end

	if (#val == 10) or (#val == 26) then
		return (val:match("^[a-fA-F0-9]+$") ~= nil)
	else
		return (#val == 5) or (#val == 13)
	end
end

function datatypes.oid(val)
	if val then
		return (val:match("^%.[0-9%.]+$") ~= nil)
	end
	return false
end

function datatypes.hexstring(val)
	if val then
		return (val:match("^[a-fA-F0-9]+$") ~= nil)
	end
	return false
end

function datatypes.hex(val, maxbytes)
	maxbytes = tonumber(maxbytes)
	if val and maxbytes ~= nil then
		return ((val:match("^0x[a-fA-F0-9]+$") ~= nil) and (#val <= 2 + maxbytes * 2))
	end
	return false
end

function datatypes.base64(val)
	if val then
		return (val:match("^[a-zA-Z0-9/+]+=?=?$") ~= nil) and (math.fmod(#val, 4) == 0)
	end
	return false
end

function datatypes.string(val)
	return true		-- Everything qualifies as valid string
end

function datatypes.directory(val, seen)
	local s = fs.stat(val)
	seen = seen or { }

	if s and not seen[s.ino] then
		seen[s.ino] = true
		if s.type == "dir" then
			return true
		elseif s.type == "lnk" then
			return directory( fs.readlink(val), seen )
		end
	end

	return false
end

function datatypes.file(val, seen)
	local s = fs.stat(val)
	seen = seen or { }

	if s and not seen[s.ino] then
		seen[s.ino] = true
		if s.type == "reg" then
			return true
		elseif s.type == "lnk" then
			return file( fs.readlink(val), seen )
		end
	end

	return false
end

function datatypes.device(val, seen)
	local s = fs.stat(val)
	seen = seen or { }

	if s and not seen[s.ino] then
		seen[s.ino] = true
		if s.type == "chr" or s.type == "blk" then
			return true
		elseif s.type == "lnk" then
			return device( fs.readlink(val), seen )
		end
	end

	return false
end

function datatypes.uciname(val)
	return (val:match("^[a-zA-Z0-9_]+$") ~= nil)
end

function datatypes.range(val, min, max)

	val = tonumber(val)
	min = tonumber(min)
	max = tonumber(max)

	if val ~= nil and min ~= nil and max ~= nil then
		return ((val >= min) and (val <= max))
	end

	return false
end

function datatypes.min(val, min)
	val = tonumber(val)
	min = tonumber(min)

	if val ~= nil and min ~= nil then
		return (val >= min)
	end

	return false
end

function datatypes.max(val, max)
	val = tonumber(val)
	max = tonumber(max)

	if val ~= nil and max ~= nil then
		return (val <= max)
	end

	return false
end

function datatypes.rangelength(val, min, max)
	val = tostring(val)
	min = tonumber(min)
	max = tonumber(max)

	if val ~= nil and min ~= nil and max ~= nil then
		return ((#val >= min) and (#val <= max))
	end

	return false
end

function datatypes.minlength(val, min)
	val = tostring(val)
	min = tonumber(min)

	if val ~= nil and min ~= nil then
		return (#val >= min)
	end

	return false
end

function datatypes.maxlength(val, max)
	val = tostring(val)
	max = tonumber(max)

	if val ~= nil and max ~= nil then
		return (#val <= max)
	end

	return false
end

function datatypes.phonedigit(val)
	return (val:match("^[0-9%*#!%.]+$") ~= nil)
end

function datatypes.timehhmmss(val)
	return (val:match("^[0-6][0-9]:[0-6][0-9]:[0-6][0-9]$") ~= nil)
end

function datatypes.dateyyyymmdd(val)
	if val ~= nil then
		yearstr, monthstr, daystr = val:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
		if (yearstr == nil) or (monthstr == nil) or (daystr == nil) then
			return false;
		end
		year = tonumber(yearstr)
		month = tonumber(monthstr)
		day = tonumber(daystr)
		if (year == nil) or (month == nil) or (day == nil) then
			return false;
		end

		local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

		local function is_leap_year(year)
			return (year % 4 == 0) and ((year % 100 ~= 0) or (year % 400 == 0))
		end

		function get_days_in_month(month, year)
			if (month == 2) and is_leap_year(year) then
				return 29
			else
				return days_in_month[month]
			end
		end
		if (year < 2015) then
			return false
		end
		if ((month == 0) or (month > 12)) then
			return false
		end
		if ((day == 0) or (day > get_days_in_month(month, year))) then
			return false
		end
		return true
	end
	return false
end

function datatypes.unique(val)
	return true
end

return datatypes
