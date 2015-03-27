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
local simplemath = require "libs/simplemath"
local simpleutils = require "libs/simpleutils"

local tab_iter = __.table_iterator

local vec_math = function (func, ...) return __ ({...}) : multi_map (func) end
local switch_args_maybe = function (_, scalar)
    if type (_) ~= "table" then _, scalar = scalar, _ end
    return _, scalar
end

local plumbing = {}

plumbing.vec_len = function (_)
    return math.sqrt (__ (_)
                        : chain ()
                        : map (simplemath.sqr)
                        : simple_reduce (simplemath.add)
                        : value ()) end

plumbing.normalize = function (_)
    local vec_len = plumbing.vec_len (_)
    return __ (_) : map(function (x) return simplemath.div (x, vec_len) end)
end

plumbing.vec_add = function (...)
    return vec_math (simplemath.multi_add, ...)
end

plumbing.vec_sub = function (...)
    return vec_math (simplemath.multi_sub, ...)
end

plumbing.vec_smult = function (_, scalar)
    _, scalar = switch_args_maybe (_, scalar)
    return __ (_) : map (__.curry (simplemath.mult, scalar))
end

plumbing.vec_sdiv = function (_, scalar)
    return plumbing.vec_smult (_, simplemath.reciprocal(scalar))
end

plumbing.vec_mult = function (...)
    return vec_math (simplemath.multi_mult, ...)
end

plumbing.vec_div = function (...)
    return vec_math (simplemath.multi_div, ...)
end

plumbing.vec_id = function (_)
    return {unpack (_)}
end


plumbing.vec_ord_perm = function (vec)
    local _1 = vec
    return __ (vec) : map (function ()
        _1 = plumbing.vec_id (_1)
        local _2 = __ (_1) : pop ()
        return __ (_1) : unshift (_2)
    end)
end

plumbing.vec_cart_prod = function (...)
    local expand_vec = function (vec, len, node_factor)
        vec = simpleutils.make_circular_list (plumbing.vec_id (vec))
        local step = 1
        return __ (__.rangeV2 (1, len))
                : map (function (idx)
                    local _ = vec[step]
                    if idx % node_factor == 0 then step = step + 1 end
                    return _ end)
    end
    local gen_node_factors = function (vecs, len)
        local _ = len
        return __ (vecs) : map (function (vec)
                                        _ = _ / #vec
                                        return _ end)
    end
    local calc_num_perms = function (...)
	    return __ ({...})
                    : chain ()
                    : map (function (_) return #_ end)
                    : simple_reduce (simplemath.mult)
                    : value ()
    end

    local len = calc_num_perms (...)
    local vecs = simpleutils.sort_by_len (...)
    local node_factors = gen_node_factors (vecs, len)
    return __ (__.rangeV2 (1, #vecs))
                    : chain ()
                    : map (function (idx) return expand_vec (vecs[idx], len, node_factors[idx]) end)
                    : zip ()
                    : value ()
end

local wrap_for_piping = function (table)
    local wrapper = function (callback, this, ...)
            if this.output then
                this.output = callback (this.output, ...)
                return this
            end
            return callback (this, ...)
        end
    __ (tab_iter(table)) : each(function (pair) 
        table[pair.key] = __.wrap (pair.value, wrapper) end)
end

return (function()
    local prototype = {unpack = function (self) return unpack (self.output) end}
    local meta = {}
    meta.__call = function (self, _)
        self.output = _
        return self
    end
    meta.__index = function (self, key)
        return plumbing[key]
    end
    wrap_for_piping (plumbing)
    return setmetatable (prototype, meta)
end)()