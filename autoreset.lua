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

_METAVALID  = setmetatable({}, { __mode = 'k' }) -- meta validator, weak keys
function setResetter(tbl, saver, name, valdefault) -- resetter function, compatible with other __newindex
    local meta = getmetatable(tbl)
    if meta and _METAVALID[meta.__newindex] then return end -- if already checked, do nothing
    if not meta then -- if no metatable, create new
        setmetatable(tbl, {})
        meta = getmetatable(tbl)
    end
    local old = meta.__newindex or rawset
    meta.__newindex = function(t, key, val) -- wrap the function or create new __newindex for already existing metatable
        saver[t][name] = valdefault
        old(t, key, val)
    end
    _METAVALID[meta.__newindex] = true -- validate
end