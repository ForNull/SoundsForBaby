local AnimalView = import("..views.AnimalView")

local ScrollView = import("..ui.ScrollView")
local AnimalList = class("AnimalList", ScrollView)

function AnimalList:ctor(size)
    AnimalList.super.ctor(self, size)

	self.tigerIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.tiger, SOUND_ANIMAL.tiger)
    self:addCell(self.tigerIcon)

    self.lionIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.lion, SOUND_ANIMAL.lion)
    self:addCell(self.lionIcon)

    self.wolfIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.wolf, SOUND_ANIMAL.wolf)
    self:addCell(self.wolfIcon)

    self.elephantIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.elephant, SOUND_ANIMAL.elephant)
    self:addCell(self.elephantIcon)

    self.horseIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.horse, SOUND_ANIMAL.horse)
    self:addCell(self.horseIcon)

    self.monkeyIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.monkey, SOUND_ANIMAL.monkey)
    self:addCell(self.monkeyIcon)

    self.cattleIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.cattle, SOUND_ANIMAL.cattle)
    self:addCell(self.cattleIcon)

    self.dogIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.dog, SOUND_ANIMAL.dog)
    self:addCell(self.dogIcon)

    self.catIcon = AnimalView.new(CCSize(display.width, display.height), IMG_ANIMAL.cat, SOUND_ANIMAL.cat)
    self:addCell(self.catIcon)

    self.scene_animal = display.newSprite(SCENE_ANIMAL )
    self.scene_animal:setPosition(display.left - self.scene_animal:getContentSize().width / 2 - 10, display.cy)
    self:addChild(self.scene_animal)
end

function AnimalList:onTouchEndedWithoutTap(event, x, y)
    local offsetX, offsetY = self.offsetX, self.offsetY
    local index = 0
    local count = #self.cells

    offsetX = -offsetX
    local x = 0
    local i = 1
    while i <= count do
        local cell = self.cells[i]
        local size = cell:getContentSize()
        if (self.drag.direction == "left" and offsetX < x + size.width / 4 ) 
            or (self.drag.direction == "right" and offsetX < x + size.width * 3 / 4) then
            index = i
            break
        end
        x = x + size.width
        i = i + 1
    end
    if i > count then index = count end

    -- audio.stopAllSounds()
    audio.stopMusic(true)
    for i,v in ipairs(self.cells) do
        v.isSoundPlaying = false
    end

    self:scrollToCell(index, true)
end

return AnimalList