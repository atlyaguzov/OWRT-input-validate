
local util = {}

function util.bigendian()
	return string.byte(string.dump(function() end), 7) == 0
end

function util.class(base)
	return setmetatable({}, {
		__call  = _instantiate,
		__index = base
	})
end

return util
