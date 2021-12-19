--[[
Gingerbread is distributed under the CC BY-SA license; additionally I do not
authorize using this project, its generated contents, and any form of
derivatives in those relating to or containing non-fungible tokens (NFT) or
blockchain related projects.

Copyright (C) 2021 Tony Wang

GitHub:  https://github.com/paladin-t/gingerbread/
Itch.io: https://tonywang.itch.io/gingerbread
]]

-- Declares a class.
function class(kls, base)
	if not base then
		base = { }
	end

	kls.new = function (...)
		local obj = { }
		setmetatable(obj, kls)
		if obj.ctor then
			obj:ctor(...)
		end

		return obj
	end

	kls.__index = kls

	setmetatable(kls, base)

	return kls
end

-- Determines whether an object is instance of a specific class.
function is(obj, kls)
	repeat
		if obj == kls then
			return true
		end
		obj = getmetatable(obj)
	until not obj

	return false
end
