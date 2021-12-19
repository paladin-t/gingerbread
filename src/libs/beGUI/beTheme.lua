--[[
The MIT License

Copyright (C) 2021 Tony Wang

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local beUtils = require 'libs/beGUI/beGUI_Utils'

local function common(guiOnly)
	local guis = {
		['label'] = {
			content_offset = nil
		},
		['label_shadow'] = {
			content_offset = { 1, 1 }
		},
		['multilinelabel'] = {
			content_offset = nil
		},

		['url'] = {
			content_offset = nil
		},
		['url_down'] = {
			content_offset = nil
		},

		['inputbox'] = {
			resource = Resources.load('imgs/widgets/panel_white.png'),
			area = { 0, 0, 17, 17 },
			content_offset = { 2, 0 }
		},

		['button'] = {
			resource = Resources.load('imgs/widgets/button.png'),
			area = { 0, 0, 23, 23 },
			content_offset = nil
		},
		['button_down'] = {
			resource = Resources.load('imgs/widgets/button.png'),
			area = { 0, 23, 23, 23 },
			content_offset = { 0, 1 }
		},
		['button_disabled'] = {
			resource = Resources.load('imgs/widgets/button.png'),
			area = { 0, 46, 23, 23 },
			content_offset = nil
		},
		['button_vanilla'] = {
			resource = Resources.load('imgs/widgets/button_vanilla.png'),
			area = { 0, 0, 23, 23 },
			content_offset = nil
		},
		['button_vanilla_down'] = {
			resource = Resources.load('imgs/widgets/button_vanilla.png'),
			area = { 0, 23, 23, 23 },
			content_offset = { 0, 1 }
		},
		['button_chocolate'] = {
			resource = Resources.load('imgs/widgets/button_chocolate.png'),
			area = { 0, 0, 23, 23 },
			content_offset = nil
		},
		['button_chocolate_down'] = {
			resource = Resources.load('imgs/widgets/button_chocolate.png'),
			area = { 0, 23, 23, 23 },
			content_offset = { 0, 1 }
		},
		['button_grass'] = {
			resource = Resources.load('imgs/widgets/button_grass.png'),
			area = { 0, 0, 23, 23 },
			content_offset = nil
		},
		['button_grass_down'] = {
			resource = Resources.load('imgs/widgets/button_grass.png'),
			area = { 0, 23, 23, 23 },
			content_offset = { 0, 1 }
		},
		['button_cherry'] = {
			resource = Resources.load('imgs/widgets/button_cherry.png'),
			area = { 0, 0, 23, 23 },
			content_offset = nil
		},
		['button_cherry_down'] = {
			resource = Resources.load('imgs/widgets/button_cherry.png'),
			area = { 0, 23, 23, 23 },
			content_offset = { 0, 1 }
		},

		['button_close'] = {
			resource = Resources.load('imgs/widgets/button_close.png'),
			area = { 0, 0, 19, 19 },
			content_offset = nil
		},
		['button_close_down'] = {
			resource = Resources.load('imgs/widgets/button_close.png'),
			area = { 0, 19, 19, 19 },
			content_offset = nil
		},

		['checkbox'] = {
			resource = Resources.load('imgs/widgets/checkbox.png'),
			area = { 0, 0, 13, 13 },
			content_offset = { 16, 1 }
		},
		['checkbox_selected'] = {
			resource = Resources.load('imgs/widgets/checkbox.png'),
			area = { 0, 13, 13, 13 },
			content_offset = { 16, 1 }
		},
		['checkbox_rounded'] = {
			resource = Resources.load('imgs/widgets/checkbox_rounded.png'),
			area = { 0, 0, 30, 17 },
			content_offset = { 0, 1 }
		},
		['checkbox_rounded_selected'] = {
			resource = Resources.load('imgs/widgets/checkbox_rounded.png'),
			area = { 0, 17, 30, 17 },
			content_offset = { 0, 1 }
		},
		['checkbox_rounded_content'] = {
			resource = Resources.load('imgs/widgets/checkbox_rounded_content.png'),
			area = { 0, 0, 17, 17 }
		},

		['radiobox'] = {
			resource = Resources.load('imgs/widgets/radiobox.png'),
			area = { 0, 0, 13, 13 },
			content_offset = { 16, 1 }
		},
		['radiobox_selected'] = {
			resource = Resources.load('imgs/widgets/radiobox.png'),
			area = { 0, 13, 13, 13 },
			content_offset = { 16, 1 }
		},

		['combobox'] = {
			resource = Resources.load('imgs/widgets/panel_gray.png'),
			area = { 0, 0, 17, 17 },
			content_offset = { 1, 1 }
		},
		['combobox_button_left'] = {
			resource = Resources.load('imgs/widgets/button_left.png'),
			area = { 0, 0, 17, 17 },
			content_offset = nil
		},
		['combobox_button_left_down'] = {
			resource = Resources.load('imgs/widgets/button_left.png'),
			area = { 0, 17, 17, 17 },
			content_offset = nil
		},
		['combobox_button_right'] = {
			resource = Resources.load('imgs/widgets/button_right.png'),
			area = { 0, 0, 17, 17 },
			content_offset = nil
		},
		['combobox_button_right_down'] = {
			resource = Resources.load('imgs/widgets/button_right.png'),
			area = { 0, 17, 17, 17 },
			content_offset = nil
		},

		['numberbox'] = {
			resource = Resources.load('imgs/widgets/panel_gray.png'),
			area = { 0, 0, 17, 17 },
			content_offset = { 1, 1 }
		},
		['numberbox_button_up'] = {
			resource = Resources.load('imgs/widgets/button_up.png'),
			area = { 0, 0, 17, 17 },
			content_offset = nil
		},
		['numberbox_button_up_down'] = {
			resource = Resources.load('imgs/widgets/button_up.png'),
			area = { 0, 17, 17, 17 },
			content_offset = nil
		},
		['numberbox_button_down'] = {
			resource = Resources.load('imgs/widgets/button_down.png'),
			area = { 0, 0, 17, 17 },
			content_offset = nil
		},
		['numberbox_button_down_down'] = {
			resource = Resources.load('imgs/widgets/button_down.png'),
			area = { 0, 17, 17, 17 },
			content_offset = nil
		},

		['progressbar'] = {
			resource = Resources.load('imgs/widgets/progressbar.png'),
			area = { 0, 0, 17, 17 },
			content_offset = { 2, 2 }
		},

		['slide'] = {
			resource = Resources.load('imgs/widgets/slide.png'),
			area = { 0, 0, 13, 17 },
			content_offset = nil
		},

		['group'] = {
			resource = nil,
			color = Color.new(0, 0, 0),
			area = nil,
			content_offset = { 8, 0 }
		},
		['group_title'] = {
			content_offset = nil
		},

		['list'] = {
			resource = Resources.load('imgs/widgets/panel_white.png'),
			color = Color.new(127, 127, 127, 128),
			area = { 0, 0, 17, 17 },
			content_offset = nil
		},

		['tab'] = {
			resource = nil,
			area = nil,
			content_offset = { 3, 3 }
		},
		['tab_title'] = {
			content_offset = nil
		},

		['window'] = {
			resource = Resources.load('imgs/widgets/window.png')
		},

		['icon_en'] = {
			resource = Resources.load('imgs/widgets/languages.png'),
			area = { 0, 0, 12, 16 }
		},
		['icon_en_down'] = {
			resource = Resources.load('imgs/widgets/languages.png'),
			area = { 0, 0, 12, 16 }
		},
		['icon_ch'] = {
			resource = Resources.load('imgs/widgets/languages.png'),
			area = { 22, 16, 11, 13 }
		},
		['icon_ch_down'] = {
			resource = Resources.load('imgs/widgets/languages.png'),
			area = { 22, 16, 11, 13 }
		},
		['icon_jp'] = {
			resource = Resources.load('imgs/widgets/languages.png'),
			area = { 0, 32, 10, 11 }
		},
		['icon_jp_down'] = {
			resource = Resources.load('imgs/widgets/languages.png'),
			area = { 0, 32, 10, 11 }
		},
	}

	if guiOnly then
		return guis
	end

	local font_ = Font.new('fonts/ascii_8x8.png', Vec2.new(8, 8))
	local fontSmall = Font.new('fonts/ascii_5x8.png', Vec2.new(5, 8))
	local fontTiny = Font.new('fonts/ascii_4x6.png', Vec2.new(4, 6))
	local fonts = {
		['font'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_red'] = {
			resource = font_,
			color = Color.new(255, 50, 50)
		},
		['font_green'] = {
			resource = font_,
			color = Color.new(3, 214, 111)
		},
		['font_blue'] = {
			resource = font_,
			color = Color.new(95, 183, 243)
		},
		['font_yellow'] = {
			resource = font_,
			color = Color.new(255, 242, 30)
		},
		['font_white'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_black'] = {
			resource = font_,
			color = Color.new(0, 0, 0)
		},
		['font_gray'] = {
			resource = font_,
			color = Color.new(128, 128, 128, 128)
		},
		['font_placeholder'] = {
			resource = font_,
			color = Color.new(138, 138, 138)
		},
		['font_title'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_url'] = {
			resource = font_,
			color = Color.new(0, 102, 255)
		},
		['font_url_hover'] = {
			resource = font_,
			color = Color.new(0, 162, 255)
		},
		['font_small'] = {
			resource = fontSmall,
			color = Color.new(0, 0, 0)
		},
		['font_tiny'] = {
			resource = fontTiny,
			color = Color.new(0, 0, 0)
		}
	}

	return beUtils.merge(guis, fonts)
end

local function default()
	local guis = common(true)
	local OFFSET = 1
	guis['label'].content_offset = { 0, OFFSET }
	guis['label_shadow'].content_offset = { 1, OFFSET + 1 }
	guis['multilinelabel'].content_offset = { 0, OFFSET }
	guis['url'].content_offset = { 0, OFFSET }
	guis['url_down'].content_offset = { 0, OFFSET }
	guis['inputbox'].content_offset = { 2, OFFSET }
	guis['button'].content_offset = { 0, OFFSET }
	guis['button_down'].content_offset = { 0, OFFSET + 1 }
	guis['button_disabled'].content_offset = { 0, OFFSET }
	guis['checkbox'].content_offset = { 16, OFFSET + 1 }
	guis['checkbox_selected'].content_offset = { 16, OFFSET + 1 }
	guis['checkbox_rounded'].content_offset = { 0, OFFSET + 1 }
	guis['checkbox_rounded_selected'].content_offset = { 0, OFFSET + 1 }
	guis['radiobox'].content_offset = { 16, OFFSET }
	guis['radiobox_selected'].content_offset = { 16, OFFSET }
	guis['combobox'].content_offset = { 1, OFFSET }
	guis['numberbox'].content_offset = { 1, 1 }
	guis['group_title'].content_offset = nil
	guis['tab_title'].content_offset = { 0, OFFSET }

	local font_ = Font.new('fonts/ascii_5x8.png', Vec2.new(5, 8))
	local fontSmall = Font.new('fonts/ascii_5x8.png', Vec2.new(5, 8))
	local fontTiny = Font.new('fonts/ascii_4x6.png', Vec2.new(4, 6))
	local fonts = {
		['font'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_red'] = {
			resource = font_,
			color = Color.new(255, 50, 50)
		},
		['font_green'] = {
			resource = font_,
			color = Color.new(3, 214, 111)
		},
		['font_blue'] = {
			resource = font_,
			color = Color.new(95, 183, 243)
		},
		['font_yellow'] = {
			resource = font_,
			color = Color.new(255, 242, 30)
		},
		['font_white'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_black'] = {
			resource = font_,
			color = Color.new(0, 0, 0)
		},
		['font_gray'] = {
			resource = font_,
			color = Color.new(128, 128, 128, 128)
		},
		['font_placeholder'] = {
			resource = font_,
			color = Color.new(138, 138, 138)
		},
		['font_title'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_url'] = {
			resource = font_,
			color = Color.new(0, 102, 255)
		},
		['font_url_hover'] = {
			resource = font_,
			color = Color.new(0, 162, 255)
		},
		['font_small'] = {
			resource = fontSmall,
			color = Color.new(0, 0, 0)
		},
		['font_tiny'] = {
			resource = fontTiny,
			color = Color.new(0, 0, 0)
		}
	}

	return beUtils.merge(guis, fonts)
end

local function chinese()
	local guis = common(true)
	local OFFSET = -2
	guis['label'].content_offset = { 0, OFFSET }
	guis['label_shadow'].content_offset = { 1, OFFSET + 1 }
	guis['multilinelabel'].content_offset = { 0, OFFSET }
	guis['url'].content_offset = { 0, OFFSET }
	guis['url_down'].content_offset = { 0, OFFSET }
	guis['inputbox'].content_offset = { 2, OFFSET }
	guis['button'].content_offset = { 0, OFFSET }
	guis['button_down'].content_offset = { 0, OFFSET + 1 }
	guis['button_disabled'].content_offset = { 0, OFFSET }
	guis['checkbox'].content_offset = { 16, OFFSET + 1 }
	guis['checkbox_selected'].content_offset = { 16, OFFSET + 1 }
	guis['checkbox_rounded'].content_offset = { 0, OFFSET + 1 }
	guis['checkbox_rounded_selected'].content_offset = { 0, OFFSET + 1 }
	guis['radiobox'].content_offset = { 16, OFFSET }
	guis['radiobox_selected'].content_offset = { 16, OFFSET }
	guis['combobox'].content_offset = { 1, OFFSET }
	guis['numberbox'].content_offset = { 1, 1 }
	guis['group_title'].content_offset = { 0, -4 }
	guis['tab_title'].content_offset = { 0, OFFSET }

	local font_ = Font.new('fonts/LanaPixel.ttf', 13, 0)
	local fontSmall = Font.new('fonts/ascii_5x8.png', Vec2.new(5, 8))
	local fontTiny = Font.new('fonts/ascii_4x6.png', Vec2.new(4, 6))
	local fonts = {
		['font'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_red'] = {
			resource = font_,
			color = Color.new(255, 50, 50)
		},
		['font_green'] = {
			resource = font_,
			color = Color.new(3, 214, 111)
		},
		['font_blue'] = {
			resource = font_,
			color = Color.new(95, 183, 243)
		},
		['font_yellow'] = {
			resource = font_,
			color = Color.new(255, 242, 30)
		},
		['font_white'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_black'] = {
			resource = font_,
			color = Color.new(0, 0, 0)
		},
		['font_gray'] = {
			resource = font_,
			color = Color.new(128, 128, 128, 128)
		},
		['font_placeholder'] = {
			resource = font_,
			color = Color.new(138, 138, 138)
		},
		['font_title'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_url'] = {
			resource = font_,
			color = Color.new(0, 102, 255)
		},
		['font_url_hover'] = {
			resource = font_,
			color = Color.new(0, 162, 255)
		},
		['font_small'] = {
			resource = fontSmall,
			color = Color.new(0, 0, 0)
		},
		['font_tiny'] = {
			resource = fontTiny,
			color = Color.new(0, 0, 0)
		}
	}

	return beUtils.merge(guis, fonts)
end

local function japanese()
	local guis = common(true)
	local OFFSET = -1
	guis['label'].content_offset = { 0, OFFSET }
	guis['label_shadow'].content_offset = { 1, OFFSET + 1 }
	guis['multilinelabel'].content_offset = { 0, OFFSET }
	guis['url'].content_offset = { 0, OFFSET }
	guis['url_down'].content_offset = { 0, OFFSET }
	guis['inputbox'].content_offset = { 2, OFFSET }
	guis['button'].content_offset = { 0, OFFSET }
	guis['button_down'].content_offset = { 0, OFFSET + 1 }
	guis['button_disabled'].content_offset = { 0, OFFSET }
	guis['checkbox'].content_offset = { 16, OFFSET + 1 }
	guis['checkbox_selected'].content_offset = { 16, OFFSET + 1 }
	guis['checkbox_rounded'].content_offset = { 0, OFFSET + 1 }
	guis['checkbox_rounded_selected'].content_offset = { 0, OFFSET + 1 }
	guis['radiobox'].content_offset = { 16, OFFSET }
	guis['radiobox_selected'].content_offset = { 16, OFFSET }
	guis['combobox'].content_offset = { 1, OFFSET }
	guis['numberbox'].content_offset = { 1, 1 }
	guis['group_title'].content_offset = { 0, -3 }
	guis['tab_title'].content_offset = { 0, OFFSET }

	local font_ = Font.new('fonts/jackeyfont.ttf', 12, 0)
	local fontSmall = Font.new('fonts/ascii_5x8.png', Vec2.new(5, 8))
	local fontTiny = Font.new('fonts/ascii_4x6.png', Vec2.new(4, 6))
	local fonts = {
		['font'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_red'] = {
			resource = font_,
			color = Color.new(255, 50, 50)
		},
		['font_green'] = {
			resource = font_,
			color = Color.new(3, 214, 111)
		},
		['font_blue'] = {
			resource = font_,
			color = Color.new(95, 183, 243)
		},
		['font_yellow'] = {
			resource = font_,
			color = Color.new(255, 242, 30)
		},
		['font_white'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_black'] = {
			resource = font_,
			color = Color.new(0, 0, 0)
		},
		['font_gray'] = {
			resource = font_,
			color = Color.new(128, 128, 128, 128)
		},
		['font_placeholder'] = {
			resource = font_,
			color = Color.new(138, 138, 138)
		},
		['font_title'] = {
			resource = font_,
			color = Color.new(255, 255, 255)
		},
		['font_url'] = {
			resource = font_,
			color = Color.new(0, 102, 255)
		},
		['font_url_hover'] = {
			resource = font_,
			color = Color.new(0, 162, 255)
		},
		['font_small'] = {
			resource = fontSmall,
			color = Color.new(0, 0, 0)
		},
		['font_tiny'] = {
			resource = fontTiny,
			color = Color.new(0, 0, 0)
		}
	}

	return beUtils.merge(guis, fonts)
end

beTheme = {
	default = default,
	chinese = chinese,
	japanese = japanese
}
