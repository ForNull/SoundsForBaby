local MenuTextView = class("MenuTextView", function()
	return display.newSprite()
end)

function MenuTextView:ctor(txtType, text, x, y, clickTag)
    if txtType == "BMFont" then
    	self.label = ui.newBMFontLabel({
            text  = text,
            font  = GAME_UIFONT_FILENAME,
            x     = x,
            y     = y,
            align = ui.TEXT_ALIGEN_CENTER,
        })
    elseif txtType == "BMFont_SC" then
        self.label = ui.newBMFontLabel({
            text  = text,
            font  = GAME_UIFONT_SC_FILENAME,
            x     = x,
            y     = y,
            align = ui.TEXT_ALIGEN_CENTER,
        })
    elseif txtType == "TTLabel" then
        self.label = ui.newTTFLabelWithShadow({
            text  = text,
            font  = "High Tower Text",
            x     = x,
            y     = y,
            align = ui.TEXT_ALIGN_CENTER,
            size  = 70,
        })
    end

    self:addChild(self.label)
    self.clickTag = clickTag

	self:setTouchEnabled(true)
	self:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end)
end

function MenuTextView:setTouched(e)
    self:setTouchEnabled(e)
    self:removeTouchEventListener()
end

function MenuTextView:setBMFontScale(scale)
    self.label:setScale(scale)
end

function MenuTextView:setTTFLabelSize(size)
    self.label.label:setFontSize(size)
    self.label.shadow1:setFontSize(size)
end

function MenuTextView:setColor(color)
    self.label:setColor(color)
end


function MenuTextView:onTouch(event, x, y)
    local sequence = transition.sequence({
        transition.moveTo(self, {x = self:getPositionX(), y = self:getPositionY() - 3, time = 0.05}),
        transition.moveTo(self, {x = self:getPositionX(), y = self:getPositionY(), time = 0.05}),
    })
    self:runAction(sequence)

    self:performWithDelay(function()
    	if self.clickTag == "car" then
            audio.playSound(GAME_SOUND.tapButton)
    		app:enterCarScene()
        elseif self.clickTag == "animal" then
            audio.playSound(GAME_SOUND.tapButton)
            app:enterAnimalScene()
        elseif self.clickTag == "rate" then
            if device.platform == "android" then
                -- device.openURL("http://play.google.com/store/apps/details?id=com.ttz320.game.sound")
                device.openURL("market://details?id=com.ttz320.game.sound")
            end
    	end
    end, 0.1)
end

return MenuTextView