-- The MIT License (MIT)

-- Copyright (c) 2015 Alex Dolinsky

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local __ = require "libs/underscore"

local simpleutils = {}

simpleutils.make_dummy_func = function ()
    return function () end
end

simpleutils.cls_circular_list = function (proto)
    proto = proto or {}
    local meta = {__index = function (l, idx)
                        idx = math.floor (idx % #l)
                        if idx == 0 then idx = #l end
                        return l[idx]
                    end}
    return setmetatable (proto, meta)
end

simpleutils.cls_safe_circular_list = function (default)
    assert (default, "default value must be provided for a safe circular list!")
    local at_default = function () return default end
    local list = simpleutils.cls_circular_list ()
    local push_callback, at_callback
    local push_default = function (_)
        at_callback = function (idx) return list[idx] end
        push_callback = __ (__.push) : curry (list)
        push_callback (_)
    end
    local restore_defaults_if = function ()
        if __ (list) : is_empty () then at_callback, push_callback = at_default, push_default end
    end
    local pop = __ (__.pop) : curry (list)
    pop = __ (pop) : wrap (function (func)
        local _ = func ()
        restore_defaults_if ()
        return _
    end)

    push_callback, at_callback = push_default, at_default

    return {push = function (_) push_callback (_) end,
            at = function (idx) return at_callback (idx) end,
            pop = pop}
end

simpleutils.cls_carousel = function (...)
    local circular_list = simpleutils.cls_safe_circular_list (simpleutils.make_dummy_func ())
    local idx = 0
    local get = function () return circular_list.at (idx) end
    local next = function () idx = simplemath.incr (idx) return get () end 
    __ ({...}) : each (function (_) circular_list.push (_) end)
    return {next = next, get = get}
end

simpleutils.sort_by_len = function (...)
    return __ ({...}) : sort (function (li1, li2) return #li1 > #li2 end)
end

return simpleutils