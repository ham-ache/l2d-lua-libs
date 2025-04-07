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
--[[
    my mini-lib for manipulating scenes - scene systems
    i am not comfortable with putting every callback function for every scene into one global overriden function
    while this can be done using a global library for manipulating this in every file
    (basically, replaces love override functions with ordered and optimized callbacks)
    
    ssys.new(scene name [string], name of the love2D callback to override [string], your function [function], order [number])

    you can create your own and call them inside of a block:
        ssys.call('to_override', args [...])
    
    you can also remove them:
        ssys['callback_name']['unique scene name'] = nil
            or
        ssys.callback_name.scene_name = nil
]]--

require 'opairs'

ssys = setmetatable({
    new = function(sName, toOverride, func, order)
        toOverride = string.lower(toOverride)
        ssys[toOverride][sName] = {func, _order = order or 0}
    end,
    call = function(toOverride, ...)
        for _, params in opairs(ssys[toOverride]) do
            params[1](...)
        end
    end,
}, {
    __index = function(t, key)
        local new = {}
        rawset(t, key, new)
        return new
    end,
})

local autoArray = {
    'draw',
    'load',
    'lowmemory',
    'quit',
    'threaderror',
    'update',
    'directorydropped',
    'displayrotated',
    'filedropped',
    'focus',
    'mousefocus',
    'resize',
    'visible',
    'keypressed',
    'keyreleased',
    'textedited',
    'textinput',
    'mousemoved',
    'mousepressed',
    'mousereleased',
    'wheelmoved',
    'gamepadaxis',
    'gamepadpressed',
    'gamepadreleased',
    'joystickadded',
    'joystickaxis',
    'joystickhat',
    'joystickpressed',
    'joystickreleased',
    'joystickremoved',
    'touchmoved',
    'touchpressed',
    'touchreleased',
}

for _, name in ipairs(autoArray) do
    love[name] = function(...)
        ssys.call(name, ...)
    end
end