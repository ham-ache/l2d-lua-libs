--[[
        MIT License

        Copyright (c) 2025 hamache

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
]]--
--- LOVE2D SHOWCASE ---
require 'opairs'
require 'love2d/ssys'

ssys.new('main', 'load', function()
    abctable = {
        ['blah'] = 165,
        ['bleh'] = 11,
        ['blae'] = 'ggqeg',
        ['1234'] = 'bruh',
    }
    ordtable = setmetatable({
        ['blah'] = {165, _order = 6612},
        ['bleh'] = {11, _order = 1},
        ['blae'] = {'ggqeg', _order = 2},
        ['1234'] = {'bruh', _order = -5},
    }, {
        __newindex = function(t, key, val)
            if val and type(val[1]) == 'number' then
                val[1] = val[1] * 5
                val[1] = val[1]..' -- edited by __newindex'
            end
            rawset(t, key, val)
        end
    })
    startid = 2
end, 0) -- order by default is 0, and 'main' scene is intended to be at 0
ssys.new('main', 'update', function()
    local time = love.timer.getTime()
    ordtable[math.floor(time)] = {time, _order = 15000+time}
end)
ssys.new('main', 'wheelmoved', function(_, y)
    startid = startid + y
end)
ssys.new('main', 'draw', function()
    love.graphics.print('opairs | sortcacher amt: '..#(_SORTCACHER[ordtable]._SORTRES or {}), 10,  10)
    love.graphics.print('opairs / alphabetic - abctable', 300, 10)
    love.graphics.print('pairs - abctable', 500, 10)

    local id = startid
    for x, t in opairs(ordtable) do
        if id > 26 then break elseif id > 1 then
            love.graphics.print(x..' = '..t[1]..' | ORDER: '..t._order, 10, 10 + 20*id)
        end
        id = id + 1
    end
    id = startid
    for x, t in opairs(abctable, true) do
        if id > 26 then break elseif id > 1 then
            love.graphics.print(x..' = '..t, 300, 10 + 20*id)
        end
        id = id + 1
    end
    id = startid
    for x, t in pairs(abctable) do
        if id > 26 then break elseif id > 1 then
            love.graphics.print(x..' = '..t, 500, 10 + 20*id)
        end
        id = id + 1
    end
end)