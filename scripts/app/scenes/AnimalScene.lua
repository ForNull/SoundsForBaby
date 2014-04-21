local AnimalList = import("..views.AnimalList")

local AnimalScene = class("AnimalScene", function()
    return display.newScene("AnimalScene")
end)

function AnimalScene:ctor()
	self.layer = display.newLayer()

    self.layer:addKeypadEventListener(function(event)
        if event == "back" then
            -- audio.playSound(GAME_SOUND.backButton)
            audio.stopMusic(true)
            app:enterMainScene()
        end
    end)
	self:addChild(self.layer)

    self.animalList = AnimalList.new(CCSize(display.width, display.height))
    self:addChild(self.animalList)
end

function AnimalScene:onEnter()   
    -- preload all sounds
    for k, v in pairs(SOUND_ANIMAL) do
        audio.preloadMusic(v)
    end

    -- avoid unmeant back
    self:performWithDelay(function()
        self.layer:setKeypadEnabled(true)
    end, 0.5)    
end

return AnimalScene