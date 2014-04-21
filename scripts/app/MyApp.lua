
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    -- display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    -- display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_ANIMAL, GAME_TEXTURE_IMAGE_ANIMAL)
    display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_BUTTON, GAME_TEXTURE_IMAGE_BUTTON)

    self:enterScene("MainScene")
end

function MyApp:enterCarScene()
    self:enterScene("CarScene", nil, "MoveInR", 1.0, display.COLOR_WHITE)
end

function MyApp:enterAnimalScene()
    self:enterScene("AnimalScene", nil, "MoveInR", 1.0, display.COLOR_WHITE)
end

function MyApp:enterMainScene()
    self:enterScene("MainScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

return MyApp
