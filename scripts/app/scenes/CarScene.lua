local CarList = import("..views.CarList")

local CarScene = class("CarScene", function()
    return display.newScene("CarScene")
end)

function CarScene:ctor()
	self.layer = display.newLayer()

    self.layer:addKeypadEventListener(function(event)
        if event == "back" then
            -- audio.playSound(GAME_SOUND.backButton)
            audio.stopMusic(true)
            app:enterMainScene()
        end
    end)
	self:addChild(self.layer)

    self.carList = CarList.new(CCSize(display.width, display.height))
    self:addChild(self.carList)
end

function CarScene:onEnter()
    for k, v in pairs(SOUND_VEHICLE) do
        audio.preloadMusic(v)
    end
    
    -- avoid unmeant back
    self:performWithDelay(function()
        self.layer:setKeypadEnabled(true)
    end, 0.5)    
end

return CarScene