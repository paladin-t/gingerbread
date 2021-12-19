--[[
Gingerbread is distributed under the CC BY-SA license; additionally I do not
authorize using this project, its generated contents, and any form of
derivatives in those relating to or containing non-fungible tokens (NFT) or
blockchain related projects.

Copyright (C) 2021 Tony Wang

GitHub:  https://github.com/paladin-t/gingerbread/
Itch.io: https://tonywang.itch.io/gingerbread
]]

local beClass = require 'libs/beGUI/beClass'
local beUtils = require 'libs/beGUI/beGUI_Utils'
local beWidget = require 'libs/beGUI/beGUI_Widget'

--[[
Widgets.
]]

local CheckBoxRounded = beClass.class({
	_pressed = false,
	_value = false,
	_floatValue = 0,

	-- Constructs a CheckBoxRounded with the specific content.
	-- `content`: the content string
	-- `value`: the initial checked state
	ctor = function (self, content, value)
		beWidget.Widget.ctor(self)

		self.content = content

		self._value = not not value
		self._floatValue = self._value and 1 or 0
	end,

	__tostring = function (self)
		return 'CheckBoxRounded'
	end,

	-- Gets whether this Widget is checked.
	getValue = function (self)
		return self._value
	end,
	-- Sets whether this Widget is checked.
	setValue = function (self, val)
		if self._value == val then
			return self
		end
		self._value = val
		self:_trigger('changed', self, self._value)

		return self
	end,

	setContent = function (self, val)
		self.content = content

		return self
	end,

	navigatable = function (self)
		return 'all'
	end,

	_update = function (self, theme, delta, dx, dy, event)
		if not self.visibility then
			return
		end

		local ox, oy = self:offset()
		local px, py = self:position()
		local x, y = dx + px + ox, dy + py + oy
		local w, h = self:size()
		local down = false
		if event.context.active and event.context.active ~= self then
			self._pressed = false
		elseif event.canceled or event.context.dragging then
			event.context.active = nil
			self._pressed = false
		elseif self._pressed then
			down = event.mouseDown
		else
			down = event.mouseDown and Math.intersects(event.mousePosition, Rect.byXYWH(x, y, w, h))
		end
		if down and not self._pressed then
			event.context.active = self
			self._pressed = true
		elseif not down and self._pressed then
			event.context.active = nil
			self._pressed = false
			event.context.focus = self
			self:setValue(not self._value)
		elseif event.context.focus == self and event.context.navigated == 'press' then
			self:setValue(not self._value)
			event.context.navigated = false
		elseif event.context.focus == self and event.context.navigated == 'press' then
			self:setValue(not self._value)
			event.context.navigated = false
		end

		if self._value and self._floatValue < 1 then
			self._floatValue = self._floatValue + delta * 10
			if self._floatValue > 1 then
				self._floatValue = 1
			end
		elseif not self._value and self._floatValue > 0 then
			self._floatValue = self._floatValue - delta * 10
			if self._floatValue < 0 then
				self._floatValue = 0
			end
		end
		local normalElem, checkedElem = theme['checkbox_rounded'], theme['checkbox_rounded_selected']
		local elem = self._value and checkedElem or normalElem
		local img = elem.resource
		local area = elem.area
		local normalImg = normalElem.resource
		local normalArea = normalElem.area
		local checkedImg = checkedElem.resource
		local checkedArea = checkedElem.area
		local contentElem = theme['checkbox_rounded_content']
		local contentImg = contentElem.resource
		local contentArea = contentElem.area
		local contentOffset = (area[3] - contentArea[3]) * self._floatValue
		if self.transparency then
			local col = Color.new(255, 255, 255, self.transparency)
			tex(img, x + w - area[3], y + (h - area[4]) * 0.5, area[3], area[4], area[1], area[2], area[3], area[4], 0, Vec2.new(0.5, 0.5), false, false, col)
			tex(contentImg, x + w - area[3] + contentOffset, y + (h - contentArea[4]) * 0.5, contentArea[3], contentArea[4], contentArea[1], contentArea[2], contentArea[3], contentArea[4], 0, Vec2.new(0.5, 0.5), false, false, col)
		else
			if self._floatValue == 0 then
				tex(normalImg, x + w - normalArea[3], y + (h - normalArea[4]) * 0.5, normalArea[3], normalArea[4], normalArea[1], normalArea[2], normalArea[3], normalArea[4])
			elseif self._floatValue == 1 then
				tex(checkedImg, x + w - checkedArea[3], y + (h - checkedArea[4]) * 0.5, checkedArea[3], checkedArea[4], checkedArea[1], checkedArea[2], checkedArea[3], checkedArea[4])
			else
				local col = Color.new(255, 255, 255, 255 * self._floatValue)
				tex(normalImg, x + w - normalArea[3], y + (h - normalArea[4]) * 0.5, normalArea[3], normalArea[4], normalArea[1], normalArea[2], normalArea[3], normalArea[4])
				tex(checkedImg, x + w - checkedArea[3], y + (h - checkedArea[4]) * 0.5, checkedArea[3], checkedArea[4], checkedArea[1], checkedArea[2], checkedArea[3], checkedArea[4], 0, Vec2.new(0.5, 0.5), false, false, col)
			end
			tex(contentImg, x + w - area[3] + contentOffset, y + (h - contentArea[4]) * 0.5, contentArea[3], contentArea[4], contentArea[1], contentArea[2], contentArea[3], contentArea[4])
		end
		beUtils.textLeft(self.content, theme['font'], x, y, w, h, elem.content_offset, self.transparency)

		beWidget.Widget._update(self, theme, delta, dx, dy, event)
	end
}, beWidget.Widget)

--[[
Exporting.
]]

assert(beGUI)

-- CheckBoxRounded widget.
-- Events:
--   'changed': function (sender, value) end
beGUI.CheckBoxRounded = CheckBoxRounded
