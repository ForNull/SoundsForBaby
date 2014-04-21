
local AnimalView = class("AnimalView", function(contentSize)
    local node = display.newNode()
    if contentSize then node:setContentSize(contentSize) end    
    node:setNodeEventEnabled(true)
    require("framework.api.EventProtocol").extend(node)
    return node
end)

function AnimalView:ctor(size, pic, sound)
	self.icon = display.newSprite(pic)

	local size = self.icon:getContentSize()
	scaleX = display.width / size.width
	scaleY = CELL_HEIGHT / size.height

	-- if scaleX < scaleY then
	-- 	self.icon:setScale(scaleX)
	-- else
	-- 	self.icon:setScale(scaleY)
	-- end
	self.icon:setScale(scaleX)

	-- local size = self.icon:getContentSize()
	-- self.icon:setScale(display.size.width / size.width)
    self:addChild(self.icon)
    self.sound = sound
    self.isSoundPlaying = false
end

function AnimalView:onTouch(event, x, y)
	-- print(222)
end

function AnimalView:onTap(x, y)
	if self.isSoundPlaying then
		-- audio.stopAllSounds()
		audio.stopMusic(true)
		self.isSoundPlaying = false
	else
		-- audio.playSound(self.sound, true)
		audio.playMusic(self.sound, true)
		self.isSoundPlaying = true
	end
end



return AnimalView