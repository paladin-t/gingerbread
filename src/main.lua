--[[
Gingerbread is distributed under the CC BY-SA license; additionally I do not
authorize using this project, its generated contents, and any form of
derivatives in those relating to or containing non-fungible tokens (NFT) or
blockchain related projects.

Copyright (C) 2021 Tony Wang

GitHub:  https://github.com/paladin-t/gingerbread/
Itch.io: https://tonywang.itch.io/gingerbread
]]

require 'libs/beGUI/beGUI'
require 'libs/beParticles/beParticles'

require 'utils/class'
require 'utils/utils'
require 'utils/keycode'
require 'utils/dictionary'
require 'utils/widgets'

local IS_HTML <const> = Platform.os == 'HTML'
local SAVED_FILE <const> = 'gingerbread.json'
local PREFAB_LIMBS <const> = {
	'limbs01',
	'limbs02',
	'limbs03',
	'limbs04',
	'limbs05',
	'limbs06',
	'limbs07',
	'limbs08',
	'limbs09'
}
local PREFAB_CLOTHS <const> = {
	'cloths01',
	'cloths02',
	'cloths03',
	'cloths04',
	'cloths05'
}
local PREFAB_FACES <const> = {
	'face01',
	'face02',
	'face03',
	'face04',
	'face05',
	'face06',
	'face07',
	'face08',
	'face09',
	'face10',
	'face11',
	'face12',
	'face13',
	'face14',
	'face15',
	'face16',
	'face17'
}
local OFFSET_X, OFFSET_Y <const> = 10, 30
local VANILLA1 <const> = Color.new(255, 255, 255, 255)
local VANILLA2 <const> = Color.new(255, 255, 255, 128)
local VANILLA3 <const> = Color.new(255, 255, 255, 64)
local CHOCOLATE1 <const> = Color.new(37, 20, 7, 255)
local CHOCOLATE2 <const> = Color.new(37, 20, 7, 128)
local CHOCOLATE3 <const> = Color.new(37, 20, 7, 64)
local GRASS1 <const> = Color.new(7, 134, 7, 255)
local GRASS2 <const> = Color.new(7, 134, 7, 128)
local GRASS3 <const> = Color.new(7, 134, 7, 64)
local CHERRY1 <const> = Color.new(255, 54, 32, 255)
local CHERRY2 <const> = Color.new(255, 54, 32, 128)
local CHERRY3 <const> = Color.new(255, 54, 32, 64)

Canvas.main:resize(360, 360)
Debug.setTimeout(0)

local localizations = nil

local mainWidgets = nil
local fortuneWidgets = nil
local theme = nil

local background = nil
local bread = nil
local parts = nil
local custom = nil
local limbs = nil
local cloths = nil
local faces = nil
local palettes = { VANILLA1, VANILLA2, VANILLA3 }
local penCache = { }
local fortuning = nil
local fortuningClip = nil

local particles = nil

local bgmTargetVolume = nil
local bgmCurrentVolume = nil
local bgm = Resources.load('bgm/auld lang syne.ogg', Music)
local clickSfx = Resources.load('sfx/click.wav', Sfx)
local eatSfx = Resources.load('sfx/eat.wav', Sfx)

local data = {
	['language'] = 'english',
	['bounded'] = true,
	['background_visible'] = true,
	['music_enabled'] = true
}

local function loadData()
	local tbl = nil
	local path = Path.combine(Path.writableDirectory, SAVED_FILE)
	local file = File.new()
	if file:open(path, Stream.Read) then
		local loadText = function ()
			file:poke(1)
			local str = file:readString()
			local json = Json:new()
			if not json:fromString(str) then
				return nil
			end

			return json:toTable()
		end
		tbl = loadText()
		file:close()
	end
	if tbl ~= nil then
		for k, v in pairs(tbl) do
			data[k] = v
		end
	end
end

local function saveData()
	local path = Path.combine(Path.writableDirectory, SAVED_FILE)
	local json = Json.new()
	json:fromTable(data)
	local str = json:toString()
	local file = File.new()
	if file:open(path, Stream.Write) then
		file:writeString(str)
		file:close()
	end
end

local function loadImage(asset)
	local bytes = Project.main:read(asset)
	bytes:poke(1)
	local img = Image.new()
	img:fromBytes(bytes)

	return img
end

local function loadParts()
	local add = function (dict, name)
		local img = loadImage('imgs/cookies/' .. name .. '.png')
		dict[name] = {
			image = img,
			texture = Resources.load(img, Texture)
		}
	end

	local img = loadImage('imgs/cookies/bread.png')
	bread = {
		image = img,
		texture = Resources.load(img, Texture)
	}

	limbs = { }
	for _, v in ipairs(PREFAB_LIMBS) do
		add(limbs, v)
	end

	cloths = { }
	for _, v in ipairs(PREFAB_CLOTHS) do
		add(cloths, v)
	end

	faces = { }
	for _, v in ipairs(PREFAB_FACES) do
		add(faces, v)
	end
end

local function shuffleParts(init)
	if init then
		parts = {
			limbs = limbs['limbs01'],
			cloth = cloths['cloths02'],
			face = faces['face01']
		}
	else
		parts = {
			limbs = limbs[any(PREFAB_LIMBS)],
			cloth = cloths[any(PREFAB_CLOTHS)],
			face = faces[any(PREFAB_FACES)]
		}
	end
end

local function clearParts()
	parts = nil
end

local function loadCustom()
	local img = Image.new()
	img:resize(241, 300)
	custom = {
		image = img,
		texture = Resources.load(img, Texture),
		prevPosition = nil,
		preview = nil
	}
end

local function plotCustom(mask, preview, img, pos)
	local x, y = pos.x, pos.y
	if data['bounded'] then
		local mcol = mask:get(x, y)
		if mcol.a < 128 then
			return
		end
	end
	local r = 2
	for j = -r, r do
		for i = -r, r do
			local hash = i + j * 97
			local idx = penCache[hash]
			if idx == nil then
				local vec = Vec2.new(i, j)
				local len = vec.length
				if len <= 1.5 then
					idx = 1
				elseif len <= 2.0 then
					idx = 2
				elseif len <= 2.5 then
					idx = 3
				else
					idx = false
				end
				penCache[hash] = idx
			end
			if idx then
				local col = palettes[idx]
				local col_ = img:get(x + i, y + j)
				if col.a >= col_.a then
					img:set(x + i, y + j, col)
				end
			end
		end
	end
	table.insert(
		preview,
		{
			position = pos,
			color = palettes[1]
		}
	)
end

local function lineCustom(mask, preview, img, pos1, pos2)
	local diff = pos2 - pos1
	local len = diff:normalize()
	local pos = pos1
	for i = 0, len + 0.5, 1 do
		plotCustom(mask, preview, img, pos)
		pos = pos + diff
	end
end

local function editCustom()
	local x, y, b1, b2, b3, wheel = mouse()
	local down = b1 and Math.intersects(Vec2.new(x, y), Rect.byXYWH(5, 25, 251, 310))
	if down and not custom.prevPosition then
		local img = custom.image
		local pos = Vec2.new(x - OFFSET_X, y - OFFSET_Y)
		custom.preview = { }
		plotCustom(bread.image, custom.preview, img, pos)
		custom.prevPosition = pos
	elseif down and custom.prevPosition then
		local img = custom.image
		local pos = Vec2.new(x - OFFSET_X, y - OFFSET_Y)
		if custom.prevPosition ~= pos then
			lineCustom(bread.image, custom.preview, img, custom.prevPosition, pos)
			custom.prevPosition = pos
		end
	elseif not down and custom.prevPosition then
		local img = custom.image
		custom.prevPosition = nil
		custom.texture = Resources.load(img, Texture)
		custom.preview = nil
	end
end

local function clearCustom()
	loadCustom()
end

local function blendColor(col1, col2)
	local a, b = col2.a / 255, 1 - col2.a / 255

	return Color.new(
		col1.r * b + col2.r * a,
		col1.g * b + col2.g * a,
		col1.b * b + col2.b * a,
		math.max(col1.a, col2.a)
	)
end

local function saveGingerbread()
	local path = nil
	if IS_HTML then
		-- Do nothing.
	else
		path = Platform.saveFile('Gingerbread', 'Image files (*.png);*.png;All files (*.*);*')
		if not path then
			return
		end
		if not endsWith(path, '.png') then
			path = path .. '.png'
		end
	end

	local w, h = 241, 300
	local x, y = math.floor((background.image.width - w) * 0.5), math.floor((background.image.height - h) * 0.5)
	local img = Image.new()
	img:resize(background.image.width, background.image.height)
	if data['background_visible'] then
		background.image:blit(img)
	else
		local white = Color.new(255, 255, 255, 0)
		for j = 0, background.image.height - 1 do
			for i = 0, background.image.width - 1 do
				img:set(i, j, white)
			end
		end
	end
	for j = 0, h - 1 do
		for i = 0, w - 1 do
			local col1 = img:get(i + x, j + y)
			local col2 = bread.image:get(i, j)
			if col2.a > 0 then
				local col = blendColor(col1, col2)
				img:set(i + x, j + y, col)
				col1 = col
			end
			if parts then
				if parts.limbs then
					col2 = parts.limbs.image:get(i, j)
					if col2.a > 0 then
						local col = blendColor(col1, col2)
						img:set(i + x, j + y, col)
						col1 = col
					end
				end
				if parts.cloth then
					col2 = parts.cloth.image:get(i, j)
					if col2.a > 0 then
						local col = blendColor(col1, col2)
						img:set(i + x, j + y, col)
						col1 = col
					end
				end
				if parts.face then
					col2 = parts.face.image:get(i, j)
					if col2.a > 0 then
						local col = blendColor(col1, col2)
						img:set(i + x, j + y, col)
						col1 = col
					end
				end
			end
			if custom then
				if custom.texture then
					col2 = custom.image:get(i, j)
					if col2.a > 0 then
						local col = blendColor(col1, col2)
						img:set(i + x, j + y, col)
						col1 = col
					end
				end
			end
		end
	end

	local bytes = Bytes.new()
	img:toBytes(bytes, 'png')
	bytes:poke(1)
	if IS_HTML then
		local base64 = Base64.encode(bytes)
		local cmd = 'gingerbreadSaveImage(\'' .. base64 .. '\')'
		Platform.execute(cmd)
	else
		local file = File.new()
		if file:open(path, Stream.Write) then
			file:writeBytes(bytes)
			file:close()
			local fi = FileInfo.new(path)
			Platform.browse(fi:parentPath())
		end
	end
end

local function spark(x, y, angle)
	if angle == nil then
		angle = 0
	end
	local emitter = beParticles.emitter.create(x, y, 0, 80, true, true)
	beParticles.ps_set_size(emitter, 0, 0, 2, nil)
	beParticles.ps_set_speed(emitter, 80, 50, 50, nil)
	beParticles.ps_set_angle(emitter, 90 - 22.5 + angle, 45)
	beParticles.ps_set_life(emitter, 2, 4)
	beParticles.ps_set_rnd_colour(emitter, true)
	beParticles.ps_set_colours(
		emitter,
		{
			Color.new(255, 0,   77,  200),
			Color.new(255, 163, 0,   200),
			Color.new(255, 236, 39,  240),
			Color.new(106, 236, 57,  240),
			Color.new(58,  235, 226, 240),
			Color.new(67,  111, 226, 240)
		}
	)

	if particles == nil then
		particles = { }
	end
	table.insert(
		particles,
		{
			emitter = emitter,
			delay = 0.2,
			interval = 10
		}
	)
end

local function reloadLocalization()
	localizations = Dictionary.new()
	if data['language'] == 'chinese' then
		localizations:load('data/chinese.json')
	elseif data['language'] == 'japanese' then
		localizations:load('data/japanese.json')
	else
		localizations:load('data/english.json')
	end
end

local function buildFortuneWidgets()
	local P = beGUI.percent -- Alias of percent.
	fortuneWidgets = beGUI.Widget.new()
		:put(0, 0)
		:resize(P(100), P(100))
		:addChild(
			beGUI.Button.new(localizations:get('back'))
				:anchor(1, 0)
				:put(P(98), 40)
				:resize(80, 20)
				:on('clicked', function (sender)
					fortuningClip = nil
					fortuneWidgets:find('multilinelabel_fortune')
						:setValue('')
					clearCustom()
					shuffleParts()
					play(clickSfx)
				end)
		)
		:addChild(
			beGUI.MultilineLabel.new('', 14)
				:setId('multilinelabel_fortune')
				:anchor(0.5, 0.5)
				:put(P(50), P(50))
				:resize(170, 20)
		)
end

local function buildMainWidgets()
	local P = beGUI.percent -- Alias of percent.
	mainWidgets = beGUI.Widget.new()
		:put(0, 0)
		:resize(P(100), P(100))
		:addChild(
			beGUI.Widget.new()
				:setId('widget_left_top_buttons')
				:anchor(0, 0)
				:put(P(2), P(2))
				:resize(69, 23)
		)
		:addChild(
			beGUI.Widget.new()
				:setId('widget_right_top_buttons')
				:anchor(1, 0)
				:put(P(98), P(2))
				:resize(80, 20)
				:addChild(
					beGUI.Button.new('')
						:anchor(0, 0)
						:put(0, 0)
						:resize(20, 20)
						:setTheme('button_vanilla', 'button_vanilla_pressed')
						:on('clicked', function (sender)
							palettes = { VANILLA1, VANILLA2, VANILLA3 }
							play(clickSfx)
						end)
				)
				:addChild(
					beGUI.Button.new('')
						:anchor(0, 0)
						:put(20, 0)
						:resize(20, 20)
						:setTheme('button_chocolate', 'button_chocolate_pressed')
						:on('clicked', function (sender)
							palettes = { CHOCOLATE1, CHOCOLATE2, CHOCOLATE3 }
							play(clickSfx)
						end)
				)
				:addChild(
					beGUI.Button.new('')
						:anchor(0, 0)
						:put(40, 0)
						:resize(20, 20)
						:setTheme('button_grass', 'button_grass_pressed')
						:on('clicked', function (sender)
							palettes = { GRASS1, GRASS2, GRASS3 }
							play(clickSfx)
						end)
				)
				:addChild(
					beGUI.Button.new('')
						:anchor(0, 0)
						:put(60, 0)
						:resize(20, 20)
						:setTheme('button_cherry', 'button_cherry_pressed')
						:on('clicked', function (sender)
							palettes = { CHERRY1, CHERRY2, CHERRY3 }
							play(clickSfx)
						end)
				)
		)
		:addChild(
			beGUI.Button.new(localizations:get('lucky'))
				:anchor(1, 0)
				:put(P(98), 40)
				:resize(80, 20)
				:on('clicked', function (sender)
					clearCustom()
					shuffleParts()
					spark(0, 200, -45)
					spark(360, 200, 45)
					play(clickSfx)
				end)
		)
		:addChild(
			beGUI.Button.new(localizations:get('clear'))
				:anchor(1, 0)
				:put(P(98), 62)
				:resize(80, 20)
				:on('clicked', function (sender)
					clearParts()
					clearCustom()
					play(clickSfx)
				end)
		)
		:addChild(
			beGUI.Button.new(localizations:get('fortune'))
				:anchor(1, 0)
				:put(P(98), 84)
				:resize(80, 20)
				:on('clicked', function (sender)
					fortuning = 0
					play(eatSfx)
				end)
		)
		:addChild(
			beGUI.Button.new(localizations:get('save'))
				:anchor(1, 0)
				:put(P(98), 106)
				:resize(80, 20)
				:on('clicked', function (sender)
					saveGingerbread()
					play(clickSfx)
				end)
		)
		:addChild(
			beGUI.CheckBoxRounded.new(localizations:get('bounded'), data['bounded'])
				:anchor(1, 0)
				:put(P(98), 128)
				:resize(80, 17)
				:on('changed', function (sender, value)
					data['bounded'] = value
					saveData()
					play(clickSfx)
				end)
		)
		:addChild(
			beGUI.CheckBoxRounded.new(localizations:get('background'), data['background_visible'])
				:anchor(1, 0)
				:put(P(98), 150)
				:resize(80, 17)
				:on('changed', function (sender, value)
					data['background_visible'] = value
					saveData()
					play(clickSfx)
				end)
		)
		:addChild(
			beGUI.CheckBoxRounded.new(localizations:get('music'), data['music_enabled'])
				:anchor(1, 0)
				:put(P(98), 172)
				:resize(80, 17)
				:on('changed', function (sender, value)
					data['music_enabled'] = value
					bgmTargetVolume = value and 0.75 or 0
					saveData()
					play(clickSfx)
				end)
		)
	local group = mainWidgets:find('widget_left_top_buttons')
	if data['language'] == 'english' then
		group
			:addChild(
				beGUI.PictureButton.new('', false, { normal = 'icon_en_down', pressed = 'icon_en_down', background_normal = 'button_down', background_pressed = 'button_down' }, true)
					:setId('button_en')
					:anchor(0, 0)
					:put(0, 0)
					:resize(23, 23)
			)
	else
		group
			:addChild(
				beGUI.PictureButton.new('', false, { normal = 'icon_en', pressed = 'icon_en_down' }, true)
					:setId('button_en')
					:anchor(0, 0)
					:put(0, 0)
					:resize(23, 23)
					:on('clicked', function (sender)
						data['language'] = 'english'
						reloadLocalization()
						buildMainWidgets()
						buildFortuneWidgets()
						saveData()
						play(clickSfx)
					end)
			)
	end
	if data['language'] == 'chinese' then
		group
			:addChild(
				beGUI.PictureButton.new('', false, { normal = 'icon_ch_down', pressed = 'icon_ch_down', background_normal = 'button_down', background_pressed = 'button_down' }, true)
					:setId('button_ch')
					:anchor(0, 0)
					:put(23, 0)
					:resize(23, 23)
			)
	else
		group
			:addChild(
				beGUI.PictureButton.new('', false, { normal = 'icon_ch', pressed = 'icon_ch_down' }, true)
					:setId('button_ch')
					:anchor(0, 0)
					:put(23, 0)
					:resize(23, 23)
					:on('clicked', function (sender)
						data['language'] = 'chinese'
						reloadLocalization()
						buildMainWidgets()
						buildFortuneWidgets()
						saveData()
						play(clickSfx)
					end)
			)
	end
	if data['language'] == 'japanese' then
		group
			:addChild(
				beGUI.PictureButton.new('', false, { normal = 'icon_jp_down', pressed = 'icon_jp_down', background_normal = 'button_down', background_pressed = 'button_down' }, true)
					:setId('button_jp')
					:anchor(0, 0)
					:put(46, 0)
					:resize(23, 23)
			)
	else
		group
			:addChild(
				beGUI.PictureButton.new('', false, { normal = 'icon_jp', pressed = 'icon_jp_down' }, true)
					:setId('button_jp')
					:anchor(0, 0)
					:put(46, 0)
					:resize(23, 23)
					:on('clicked', function (sender)
						data['language'] = 'japanese'
						reloadLocalization()
						buildMainWidgets()
						buildFortuneWidgets()
						saveData()
						play(clickSfx)
					end)
			)
	end
	if data['language'] == 'chinese' then
		theme = beTheme.chinese()
	elseif data['language'] == 'japanese' then
		theme = beTheme.japanese()
	else
		theme = beTheme.default()
	end
end

function setup()
	loadData()

	local img = loadImage('imgs/cookies/background.png')
	background = {
		image = img,
		texture = Resources.load(img, Texture)
	}
	
	beParticles.setup()

	bgmCurrentVolume = data['music_enabled'] and 0.75 or 0
	volume(0.75, bgmCurrentVolume)
	play(bgm, true, 2)

	reloadLocalization()

	buildMainWidgets()
	buildFortuneWidgets()

	loadParts()
	loadCustom()
	shuffleParts(true)
end

function quit()
	saveData()
end

function update(delta)
	if bgmTargetVolume ~= nil then
		if bgmCurrentVolume < bgmTargetVolume then
			bgmCurrentVolume = bgmCurrentVolume + delta * 0.7
			if bgmCurrentVolume >= bgmTargetVolume then
				bgmCurrentVolume = bgmTargetVolume
				bgmTargetVolume = nil
			end
		elseif bgmCurrentVolume > bgmTargetVolume then
			bgmCurrentVolume = bgmCurrentVolume - delta * 0.7
			if bgmCurrentVolume <= bgmTargetVolume then
				bgmCurrentVolume = bgmTargetVolume
				bgmTargetVolume = nil
			end
		else
			bgmTargetVolume = nil
		end
		volume(-1, bgmCurrentVolume)
	end

	if fortuning ~= nil then
		fortuning = fortuning + delta
		if fortuningClip == nil then
			fortuningClip = 1
		elseif fortuningClip == 1 and fortuning >= 0.4 then
			fortuningClip = 2
			fortuning = 0
		elseif fortuningClip == 2 and fortuning >= 0.4 then
			fortuningClip = 3
			fortuning = 0
		elseif fortuningClip == 3 and fortuning >= 0.4 then
			fortuningClip = 4
			fortuning = nil
			spark(0, 200, -45)
			spark(360, 200, 45)
			local fortune = any(localizations:get('fortunes'))
			fortune = localizations:format('your revelation word is {1}', fortune)
			--[[
			local tmp = ''
			for _, v in ipairs(localizations:get('fortunes')) do
				tmp = tmp .. v .. ' '
			end
			fortune = tmp
			]]
			fortuneWidgets:find('multilinelabel_fortune')
				:setValue(fortune)
		end
	end

	if data['background_visible'] then
		tex(background.texture, 0, 0)
	end
	if fortuningClip then
		clip(0, 359 * (fortuningClip / 3), 360, 360)
	end
	if fortuningClip ~= 4 then
		tex(bread.texture, OFFSET_X, OFFSET_Y)
		if parts then
			if parts.limbs then
				tex(parts.limbs.texture, OFFSET_X, OFFSET_Y)
			end
			if parts.cloth then
				tex(parts.cloth.texture, OFFSET_X, OFFSET_Y)
			end
			if parts.face then
				tex(parts.face.texture, OFFSET_X, OFFSET_Y)
			end
		end
		if custom then
			if custom.texture then
				tex(custom.texture, OFFSET_X, OFFSET_Y)
			end
			if custom.preview then
				for _, p in ipairs(custom.preview) do
					circ(p.position.x + OFFSET_X, p.position.y + OFFSET_Y, 2, true, p.color)
				end
			end
		end
	end
	if fortuningClip then
		clip()
	end

	beParticles.update_time()
	if particles ~= nil then
		local delta_ = math.min(delta, 0.024)
		local dead = nil
		for i, entry in ipairs(particles) do
			if entry.delay then
				entry.delay = entry.delay - delta_
				if entry.delay <= 0 then
					entry.delay = nil
				end
			end

			if entry.delay == nil then
				local emitter = entry.emitter
				emitter:update(delta_)
				emitter:draw()

				entry.interval = entry.interval - delta_
				if entry.interval <= 0 or #emitter.particles == 0 then
					if dead == nil then
						dead = { }
					end
					table.insert(dead, 1, i)
				end
			end
		end
		if dead ~= nil then
			for _, idx in ipairs(dead) do
				table.remove(particles, idx)
			end
			if #particles == 0 then
				particles = nil
			end
		end
	end

	if fortuning == nil and fortuningClip == nil then
		if keyp(KeyCode.Up) then
			mainWidgets:navigate('prev')
		elseif keyp(KeyCode.Down) then
			mainWidgets:navigate('next')
		elseif keyp(KeyCode.Left) then
			mainWidgets:navigate('dec')
		elseif keyp(KeyCode.Right) then
			mainWidgets:navigate('inc')
		elseif keyp(KeyCode.Return) then
			mainWidgets:navigate('press')
		elseif keyp(KeyCode.Esc) then
			mainWidgets:navigate('cancel')
		end

		font(theme['font'].resource)
		mainWidgets:update(theme, delta)
		font(nil)

		editCustom()
	else
		if keyp(KeyCode.Up) then
			fortuneWidgets:navigate('prev')
		elseif keyp(KeyCode.Down) then
			fortuneWidgets:navigate('next')
		elseif keyp(KeyCode.Left) then
			fortuneWidgets:navigate('dec')
		elseif keyp(KeyCode.Right) then
			fortuneWidgets:navigate('inc')
		elseif keyp(KeyCode.Return) then
			fortuneWidgets:navigate('press')
		elseif keyp(KeyCode.Esc) then
			fortuneWidgets:navigate('cancel')
		end

		-- local event = {
		-- 	mousePosition = Vec2.new(NaN(), NaN()),
		-- 	mouseDown = false,
		-- 	mouseWheel = 0,
		-- 	canceled = false,
		-- 	context = {
		-- 		navigated = nil,
		-- 		focus = nil,
		-- 		active = nil,
		-- 		dragging = nil,
		-- 		popup = nil
		-- 	}
		-- }
		font(theme['font'].resource)
		fortuneWidgets:update(theme, delta)
		font(nil)
	end
end
