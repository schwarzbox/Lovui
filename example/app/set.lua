-- LOVUI
-- set.lua

local SET = {
    APPNAME = love.window.getTitle(),
    VER = '1.0',
    SAVE = 'lovuisave.lua',
    FULLSCR = love.window.getFullscreen(),
    WID = love.graphics.getWidth(),
    HEI = love.graphics.getHeight(),
    MIDWID = love.graphics.getWidth() / 2,
    MIDHEI = love.graphics.getHeight() / 2,
    SCALE = 1,
    WHITE = {1,1,1,1},
    BLACK = {0,0,0,1},
    RED = {1,0,0,1},
    GREEN = {0,1,0,1},
    BLUE = {0,0,1,1},
    GRAY = {0.5,0.5,0.5,1},
    DARKGRAY = {32/255,32/255,32/255,1},
    MAINFNT = nil,
}
SET.GAMEFNT = {SET.MAINFNT,16}
SET.BGCLR = SET.DARKGRAY
SET.TXTCLR = SET.WHITE

return SET



