local MenuTextView = import("..ui.MenuTextView")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self.layer = display.newLayer()
    self:addChild(self.layer)

    local bg = display.newSprite(BG_MAIN, display.cx, display.cy)
    self.layer:addChild(bg)

    local title = MenuTextView.new("BMFont", "Sounds For Baby", display.cx, display.top - 180)
    title:setTouched(false)
    -- title:setBMFontScale(1.2)
    title:setColor(ccc3(251,200,55))
    self.layer:addChild(title)

    local carText = MenuTextView.new("TTLabel", "Vehicles", display.cx, display.top - 350, "car")
    -- carText:setTTLabelSize(70)
    self.layer:addChild(carText)

    local animalText = MenuTextView.new("TTLabel", "Animals", display.cx, display.top - 470, "animal")
    -- animalText:setTTLabelSize(70)
    self.layer:addChild(animalText)

    local rateText = MenuTextView.new("TTLabel", "Rate App", display.cx - 100, display.top - 650, "rate")
    rateText:setTTFLabelSize(50)
    self.layer:addChild(rateText)

    if device.platform == "android" then
        self.layer:addKeypadEventListener(function(event)
            if event == "back" then
                -- app:exit()
                CCDirector:sharedDirector():endToLua()
            end
        end)
    end

end

function MainScene:onEnter()
    -- avoid unmeant back
    self:performWithDelay(function()
        self.layer:setKeypadEnabled(true)
    end, 0.5)
end

function MainScene:onExit()
end

return MainScene
