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

require 'autoreset'

_SORTCACHER = setmetatable({}, { -- sort results cache
    __mode = 'k', -- weak keys
    __index = function(t, key)
        local new = {}
        rawset(t, key, new)
        return new
    end, -- nonexistent table index is created in case there is not
})
local sortfunc = { -- sort functions, used in opairs
    _SORTRES = function(tbl) -- manual sort
        local SORTED = {}
        for x, t in pairs(tbl) do
            if t._order ~= nil then
                table.insert(SORTED, {t, x, t._order})
            end
        end
        table.sort(SORTED, function(a, b) return a[3] < b[3] end)
        return SORTED
    end,
    _SORTRESABC = function(tbl) -- alphabetic sort
        local SORTED = {}
        for x, t in pairs(tbl) do
            table.insert(SORTED, {t, x})
        end
        table.sort(SORTED, function(a, b) return a[2] < b[2] end)
        return SORTED
    end
}
function changeOrder(tbl, key, new)
    tbl[key]._order = new
    _SORTCACHER[tbl]._SORTRES = nil
end
function opairs(tbl, alphabetic_sort)
    local cur_sort = alphabetic_sort and '_SORTRESABC' or '_SORTRES'
    local id = 0
    local SORTED = {}

    setResetter(tbl, _SORTCACHER, cur_sort)
    if _SORTCACHER[tbl][cur_sort] then
        SORTED = _SORTCACHER[tbl][cur_sort]
    else
        SORTED = sortfunc[cur_sort](tbl)
        _SORTCACHER[tbl][cur_sort] = SORTED
    end
    return function()
        id = id + 1
        if not SORTED[id] then return end
        return SORTED[id][2], SORTED[id][1]
    end
end