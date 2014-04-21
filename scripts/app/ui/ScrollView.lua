local ScrollView = class("ScrollView", function(contentSize)
    local node = display.newNode()
    if contentSize then node:setContentSize(contentSize) end
    node:setNodeEventEnabled(true)
    require("framework.api.EventProtocol").extend(node)
    return node
end)

function ScrollView:ctor(size)
	self.layer = display.newLayer()
	self:addChild(self.layer)
	self.layer:setTouchEnabled(true)
	self.layer:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end)

    self.cells = {}
    self.offsetX = 0
    self.offsetY = 0
    self.currentIndex = 1
    self.dragThreshold = 40
    self.bouncThreshold = 140
    self.defaultAnimateTime = 0.4
    self.defaultAnimateEasing = "backOut"

    self.leftIcon = display.newSprite("#left_b.png", display.cx - 230, display.top - 200)
    self.leftIcon:setOpacity(128)
    self:addChild(self.leftIcon)

    self.rightIcon = display.newSprite("#right_b.png", display.cx + 230, display.top - 200)
    self.rightIcon:setOpacity(128)
    self:addChild(self.rightIcon)

    self.backIcon = display.newSprite(BACK_BUTTON, display.right - 50, display.bottom + 70)
    -- self.backIcon:setOpacity(128)
    self:addChild(self.backIcon)
end

function ScrollView:setContentOffset(offset, animated, time, easing)
    local ox, oy = self.offsetX, self.offsetY
    local x, y = ox, oy

    self.offsetX = offset
    x = offset

    -- print("x="..x)
    -- print(self.layer:getContentSize().width)
    local maxX = self.bouncThreshold
    local minX = -self.layer:getContentSize().width - self.bouncThreshold + display.width * 1.5

    if x > maxX then
        x = maxX
    elseif x < minX then
        x = minX
    end

    if animated then
        transition.stopTarget(self.layer)
        transition.moveTo(self.layer, {
            x = x,
            y = y,
            time = time or self.defaultAnimateTime,
            easing = easing or self.defaultAnimateEasing,
        })
    else
        self.layer:setPosition(x, y)
    end
end

function ScrollView:setDirectionButton()
    if self.currentIndex <= 1 then
        self.leftIcon:setVisible(false)
    end

    if self.currentIndex > 1 then
        self.leftIcon:setVisible(true)
    end

    if self.currentIndex >= #self.cells then
        self.rightIcon:setVisible(false)
    end

    if self.currentIndex < #self.cells then
        self.rightIcon:setVisible(true)
    end
end

function ScrollView:checkDirectionButton(x, y)
    local pos = CCPoint(x, y)
    if self.leftIcon:getBoundingBox():containsPoint(pos) then
        local spriteFrame = display.newSpriteFrame("left_a.png")
        self.leftIcon:setDisplayFrame(spriteFrame)
    elseif self.rightIcon:getBoundingBox():containsPoint(pos) then
        local spriteFrame = display.newSpriteFrame("right_a.png")
        self.rightIcon:setDisplayFrame(spriteFrame)
    end
end

function ScrollView:reorderAllCells()
    local count = #self.cells
    local x, y = display.cx, display.cy
    local maxWidth, maxHeight = 0, 0
    for i = 1, count do
        local cell = self.cells[i]
        cell:setPosition(x, y)
        -- local width = cell:getContentSize().width
        -- if width > maxWidth then maxWidth = width end
        x = x + display.width
    end

    if count > 0 then
        if self.currentIndex < 1 then
            self.currentIndex = 1
        elseif self.currentIndex > count then
            self.currentIndex = count
        end
    else
        self.currentIndex = 0
    end

    local size = CCSize(x, maxHeight)
    self.layer:setContentSize(size)

    self:setDirectionButton()
end

function ScrollView:getCurrentCell()
    if self.currentIndex > 0 then
        return self.cells[self.currentIndex]
    else
        return nil
    end
end

function ScrollView:getCurrentIndex()
    return self.currentIndex
end

function ScrollView:setCurrentIndex(index)
    self:scrollToCell(index)
end

function ScrollView:addCell(cell)
    self.layer:addChild(cell)
    self.cells[#self.cells + 1] = cell
    self:reorderAllCells()
    self:dispatchEvent({name = "addCell", count = #self.cells})
end

function ScrollView:insertCellAtIndex(cell, index)
    self.view:addChild(cell)
    table.insert(self.cells, index, cell)
    self:reorderAllCells()
    self:dispatchEvent({name = "insertCellAtIndex", index = index, count = #self.cells})
end

function ScrollView:removeCellAtIndex(index)
    local cell = self.cells[index]
    cell:removeSelf()
    table.remove(self.cells, index)
    self:reorderAllCells()
    self:dispatchEvent({name = "removeCellAtIndex", index = index, count = #self.cells})
end

function ScrollView:scrollToCell(index, animated, time, easing)
    local count = #self.cells
    if count < 1 then
        self.currentIndex = 0
        return
    end

    if index < 1 then
        index = 1
    elseif index > count then
        index = count
    end
    self.currentIndex = index

    local offset = 0
    for i = 2, index do
        local cell = self.cells[i - 1]
        local size = cell:getContentSize()
        offset = offset - size.width
    end

    self:setDirectionButton()

    self:setContentOffset(offset, animated, time, easing)
    self:dispatchEvent({name = "scrollToCell", animated = animated, time = time, easing = easing})
end

function ScrollView:onTouchEndedWithoutTap(event, x, y)
     error("ScrollView:onTouchEndedWithoutTap() - inherited class must override this method")
end

function ScrollView:onTouchEndedWithTap(event, x, y)
    local pos = CCPoint(x, y)
    if self.leftIcon:getBoundingBox():containsPoint(pos) then
        -- audio.stopAllSounds()
        audio.stopMusic(true)
        for i,v in ipairs(self.cells) do
            v.isSoundPlaying = false
        end

        if self.currentIndex > 1 then
            audio.playSound(GAME_SOUND.tapButton)
        end

        self:scrollToCell(self.currentIndex - 1, false)
    elseif self.rightIcon:getBoundingBox():containsPoint(pos) then
        -- audio.stopAllSounds()
        audio.stopMusic(true)
        for i,v in ipairs(self.cells) do
            v.isSoundPlaying = false
        end

        if self.currentIndex < #self.cells then
            audio.playSound(GAME_SOUND.tapButton)
        end

        self:scrollToCell(self.currentIndex + 1, false)
    elseif self.backIcon:getBoundingBox():containsPoint(pos) then
        -- audio.stopAllSounds()
        audio.stopMusic(true)
        for i,v in ipairs(self.cells) do
            v.isSoundPlaying = false
        end

        audio.playSound(GAME_SOUND.backButton)
        app:enterMainScene()
    else
        local cell = self:getCurrentCell()
        cell:onTouch(event, x, y)
        cell:onTap(x, y)
    end
end

function ScrollView:onTouchMoved(event, x, y)
	if self.drag.isTap and math.abs(x - self.drag.startX) >= self.dragThreshold then
        self.drag.isTap = false
    end

    if not self.drag.isTap then
        self:setContentOffset(x - self.drag.startX + self.drag.currentOffsetX)
    end

    if x - self.drag.startX < 0 then
        self.drag.direction = "left"
    else
        self.drag.direction = "right"
    end
end

function ScrollView:onTouchEnded(event, x, y)
    if self.drag.isTap then
        self:onTouchEndedWithTap(event, x, y)
    else
        self:onTouchEndedWithoutTap(event, x, y)
    end
    self.drag = nil

    local spriteFrame1 = display.newSpriteFrame("left_b.png")
    self.leftIcon:setDisplayFrame(spriteFrame1)
    local spriteFrame2 = display.newSpriteFrame("right_b.png")
    self.rightIcon:setDisplayFrame(spriteFrame2)
end

function ScrollView:onTouchBegan(event, x, y)
    self.drag = {
        currentOffsetX = self.offsetX,
        currentOffsetY = self.offsetY,
        startX = x,
        startY = y,
        isTap = true,
        direction = nil,
    }

    self:checkDirectionButton(x, y)
    return true
end

function ScrollView:onTouch(event, x, y)
	if event == "began" then
		return self:onTouchBegan(event, x, y)
	elseif event == "moved" then
		self:onTouchMoved(event, x, y)
	elseif event == "ended" then
		self:onTouchEnded(event, x, y)
	else --cancelled
	end

	return true
end


return ScrollView