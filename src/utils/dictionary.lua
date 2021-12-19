--[[
Gingerbread is distributed under the CC BY-SA license; additionally I do not
authorize using this project, its generated contents, and any form of
derivatives in those relating to or containing non-fungible tokens (NFT) or
blockchain related projects.

Copyright (C) 2021 Tony Wang

GitHub:  https://github.com/paladin-t/gingerbread/
Itch.io: https://tonywang.itch.io/gingerbread
]]

Dictionary = class({
	_dictionary = nil,
	_allowNil = false,
	_mustExist = false,

	ctor = function (self, allowNil, mustExist)
		self._allowNil = allowNil
		self._mustExist = mustExist
	end,

	__tostring = function (self)
		return 'Dictionary'
	end,

	__pairs = function (self)
		local next_ = function (this, k)
			local v = nil
			k, v = next(this._dictionary, k)

			if v ~= nil then
				return k, v
			end
		end

		return next_, self, nil
	end,

	exists = function (self, key)
		if self._dictionary == nil then
			return false
		end

		return self._dictionary[key] ~= nil
	end,
	get = function (self, key)
		if self._dictionary == nil then
			return nil
		end

		if self._allowNil then
			return self._dictionary[key]
		end

		local result = self._dictionary[key]
		if result == nil then
			result = tostring(key) .. '?'

			if self._mustExist then
				error('Cannot find dictionary item for: "' .. tostring(key) .. '".\n' .. Debug.trace())
			end
		end

		return result
	end,
	format = function (self, key, ...)
		local fmt = self:get(key)
		if fmt == nil then
			return nil
		end

		local args = table.pack(...)
		for i = 1, #args do
			fmt = fmt:gsub('%' .. '{' .. tostring(i) .. '}', tostring(args[i]))
		end

		return fmt
	end,
	load = function (self, asset)
		local json = nil
		if type(asset) == 'string' then
			local bytes = Project.main:read(asset)
			bytes:poke(1)
			local str = bytes:readString()
			json = Json.new()
			json:fromString(str)
		else
			json = asset
		end

		if self._dictionary == nil then
			self._dictionary = { }
		end
		self._dictionary = merge(self._dictionary, json:toTable())

		return self
	end,
	unload = function (self)
		self._dictionary = nil

		return self
	end
})
