#!/usr/bin/env love
-- UI
-- 2.5
-- LOVUI (love2d)

-- lua<5.3
local unpack = table.unpack or unpack
local utf8 = require('utf8')

local ui = require('lovui')

io.stdout:setvbuf('no')
local set = {
    APPNAME = 'UI',
    VER = '2.5',
    FULLSCR = false,
    WID = love.graphics.getWidth(),
    HEI = love.graphics.getHeight(),
    MIDWID = love.graphics.getWidth() / 2,
    MIDHEI = love.graphics.getHeight() / 2,

    WHITE = {1,1,1,1}, BLACK = {0,0,0,1},
    RED = {1,0,0,1}, GREEN = {0,1,0,1}, BLUE = {0,0,1,1},
    GRAY = {0.5,0.5,0.5,1}, DARKGRAY = {32/255,32/255,32/255,1},
    MAINFNT = nil,
}
set.GAMEFNT = {set.MAINFNT,16}
set.BGCLR = set.DARKGRAY
set.TXTCLR = set.WHITE

local function resize(image_data, scale)
    scale = scale or 1
    local sx, sy = image_data:getDimensions()
    local data = love.image.newImageData(math.ceil(sx*scale),
                                          math.ceil(sy*scale))
    for x=1, sx do
        for y=1, sy do
            local r,g,b,a = image_data:getPixel(x-1, y-1)
            local initx = math.floor((x-1)*scale)
            local inity = math.floor((y-1)*scale)
            data:setPixel(initx,inity, r,g,b,a )
            for dx=0,scale-1 do
                for dy=0,scale-1 do
                    data:setPixel(initx+dx,inity+dy, r,g,b,a)
                end
            end
        end
    end
    return data
end

local function imageFromMatrix(mat, color, scale)
    scale = scale or 1
    local sx = #mat[1]
    local sy = #mat
    local data = love.image.newImageData(sx, sy)
    for y=1,sy do
        for x=1,sx do
            if mat[y][x] and mat[y][x]~=0 then
                data:setPixel((x-1),(y-1), unpack(color))
            end
        end
    end
    if scale~=1 then data = resize(data, scale) end
    return data
end

-- variables for ui
local check = {bool=false}
local drag = {bool=false}
local inputvar = {val=''}
local labelsel = {val='    Label    '}
local listvar = {val=''}
local progbar1 = {val=5}
local progbar2 = {val=0}
local cross = imageFromMatrix({{0,1,0}, {1,0,1}, {0,1,0}}, set.GRAY,8)
local crossvar = {val='1'}

local function uiScreen()
    ui.Manager.clear()

    ui.Sep{x=set.MIDWID-4, y=4, anchor='n'}
    ui.Sep{x=set.MIDWID, y=2, anchor='n'}
    ui.Sep{x=set.MIDWID+4, y=4, anchor='n'}

    ui.LabelExe{text='LabelExe',x=set.MIDWID,y=set.HEI-50,anchor='s',time=180,
                                                image=cross,da=2}

    local menu = ui.HBox{x=set.MIDWID, y=96,frm=10, drag=true}
    menu:add(ui.Label{text='Press Right Mouse Button for use PopUp element'})

    local main_menu = ui.HBox{x=set.MIDWID, y=set.MIDHEI,frm=8,mode='fill'}
    local menu_col1 = ui.VBox()
    local menu_col2 = ui.VBox()

    local menu_row1 = ui.HBox()
    menu_row1:add(ui.Label{text='    Label    ',var=labelsel},
                ui.Input{text='Input',var=inputvar,frm=4})
    menu_row1.items[2]:setFnt(set.GAMEFNT)

    local menu_row2 = ui.HBox{frm=20,frmclr={64/255,64/255,64/255,1}}
    menu_row2:add(ui.Selector{text='Selector1',var=labelsel},ui.Sep(),
                ui.Selector{text='Selector2',var=labelsel})

    local menu_row3 = ui.HBox()
    menu_row3:add(ui.CheckBox{text='CheckBox',var=check,frm=8,
                                com=function(box)
                                    if check.bool then
                                        box.text='Box'
                                        menu_row1:get('items')[2]:clear()
                                    else
                                        box.text='CheckBox'
                                    end
                                end},
                ui.Button{text='Button',
                com=function() labelsel.val = 'Label' end})

    local menu_row4 = ui.HBox()
    menu_row4:add(ui.Slider{text='Slider',var=progbar1,max=80},
                  ui.Counter{text='Counter',var=progbar2})

    local menu_row5 = ui.HBox()
    menu_row5:add(ui.ProgBar{text='ProgBar',var=progbar1},
                  ui.ProgBar{text='ProgBar',image=cross, da=2,
                  var=progbar2,max=4})

    local but=ui.Button{text='Show LabelExe',com=function()
                    ui.LabelExe{x=set.MIDWID,y=8,text='UI',anchor='n'} end}


    local disp = ui.Label{text='Display'}
    local list = ui.List{text='List',var=listvar,items={},mode='fill',
                        com=function() disp:set({text=listvar.val}) end}
    local flist = ui.FoldList{text='FoldList',items={' 1 ',' 2 ',' 3 '}}

    menu_col1:add(list,ui.Sep(),disp,ui.Sep(),flist)
    menu_col2:add(menu_row1,menu_row2,menu_row3,menu_row4,menu_row5,
                    ui.Sep(),but)

    main_menu:add(menu_col1,menu_col2)

    local bottom_menu = ui.HBox{x=set.MIDWID, y=set.HEI-2,anchor='s',
                                frm=8,mode='fill'}
    bottom_menu:add(ui.Button{text='Hide',
                com=function() main_menu:setHide(true) end},
            ui.Button{text='Show',
                com=function() main_menu:setHide(false) end},
            ui.Sep(),
            ui.CheckBox{text='Drag',var=drag,
                com=function() main_menu:setDrag(drag.bool) end},
            ui.Button{text='Exit',
                com=function() love.event.quit() end})

    local popup = ui.PopUp{text='PopUp'}
    popup:add(ui.CheckBox{text='Drag',var=drag,
                    com=function() main_menu:setDrag(drag.bool) end},
                ui.Sep(),
                ui.Selector{text='1',image=cross,var=crossvar},
                ui.Selector{text='2',image=cross,var=crossvar},
                ui.Sep(),
                ui.Button{text='Exit',  frm=0,
                    com=function() love.event.quit() end})

    popup:setFnt(set.GAMEFNT)
end

function love.load()
    if arg[1] then print(set.VER, set.APPNAME, 'Game (love2d)', arg[1]) end
    love.window.setFullscreen(set.FULLSCR, 'desktop')
    love.graphics.setBackgroundColor(set.BGCLR)
    -- init
    ui.init()
    uiScreen()
end

function love.update(dt)
    local title = string.format('%s %s fps %.2d obj %d',
                            set.APPNAME, set.VER, love.timer.getFPS(),
                            ui.Manager.len())
    love.window.setTitle(title)
    ui.Manager.update(dt)
end

function love.draw()
    ui.Manager.draw()
end

function love.filedropped(file)
    print(file:getFilename())
end

function love.textinput(t) end
function love.keypressed(key,unicode,isrepeat)
    if key=='escape' then love.event.quit() end
    if key=='space'then ui.LabelExe{x=set.MIDWID,y=0,text='UI',anchor='n'} end
    if key=='lgui' then love.event.quit('restart') end
end
function love.keyreleased(key,unicode) end
function love.mousepressed(x,y,button,istouch) end
function love.mousereleased(x,y,button,istouch) end
function love.mousemoved(x,y,dx,dy,istouch) end
function love.wheelmoved(x, y) end
