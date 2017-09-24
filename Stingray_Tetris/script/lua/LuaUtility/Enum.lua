local Enum = {}
local lenKey = "len"
local _ = {}
setmetatable(_, {__mode = "k"})

function Enum:__len()
	local i = 0
	for k, v in pairs(_[self]) do
		if k ~= lenKey then
			i = i + 1
		end
	end
	return i
end

function Enum:new(o)
	local t = {}
	_[t] = {[lenKey] = Enum.__len}
	for k, v in pairs(o) do
		if tonumber(k) ~= nil then
			k, v = v, k - 1
		end
		if _[t][k] ~= nil then
			error('"' .. k .. '" can not be set.', 2)
		end
		_[t][k] = v
	end
	return setmetatable(t, self)
end

function Enum:__index(k)
	if _[self][k] == nil then
		error('"' .. k .. '" is undefined enumerator.', 2)
	end
	return _[self][k]
end

function Enum:__newindex()
	error("Enum is read-only.", 2)
end

return Enum