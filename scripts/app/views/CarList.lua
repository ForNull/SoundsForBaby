local CarView = import("..views.CarView")

local ScrollView = import("..ui.ScrollView")
local CarList = class("CarList", ScrollView)

function CarList:ctor(size)
    CarList.super.ctor(self, size)

	self.ambulanceIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.ambulance, SOUND_VEHICLE.ambulance)
    self:addCell(self.ambulanceIcon)

    self.fireTruckIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.fire, SOUND_VEHICLE.fire)
    self:addCell(self.fireTruckIcon)

    self.policeIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.police, SOUND_VEHICLE.police)
    self:addCell(self.policeIcon)

    self.carIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.car, SOUND_VEHICLE.car)
    self:addCell(self.carIcon)

    self.f1Icon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.f1, SOUND_VEHICLE.f1)
    self:addCell(self.f1Icon)

    self.helicopterIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.helicopter, SOUND_VEHICLE.helicopter)
    self:addCell(self.helicopterIcon)

    self.railIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.rail, SOUND_VEHICLE.rail)
    self:addCell(self.railIcon)

    self.SteamTrainIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.SteamTrain, SOUND_VEHICLE.SteamTrain)
    self:addCell(self.SteamTrainIcon)

    self.subwayIcon = CarView.new(CCSize(display.width, display.height), IMG_VEHICLE.subway, SOUND_VEHICLE.subway)
    self:addCell(self.subwayIcon)

    self.scene_car = display.newSprite(SCENE_CAR)
    self.scene_car:setPosition(display.left - self.scene_car:getContentSize().width / 2 - 10, display.cy)
    self:addChild(self.scene_car)
end

function CarList:onTouchEndedWithoutTap(event, x, y)
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

return CarList