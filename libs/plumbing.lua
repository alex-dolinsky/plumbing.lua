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
local table_iterator = __.table_iterator

local add = function(x, y) return x + y end
local sub = function(x, y) return x - y end
local mult = function(x, y) return x * y end
local div = function(x, y) return x / y end
local sqrt = function(x) return x * x end
local single_to_multi = function(func, ...) return __({...}):simple_reduce(func) end
local multi_add = function(...) return single_to_multi(add, ...) end
local multi_sub = function(...) return single_to_multi(sub, ...) end
local multi_mult = function(...) return single_to_multi(mult, ...) end
local multi_div = function(...) return single_to_multi(div, ...) end
local multi_sqrt = function(...) return single_to_multi(sqrt, ...) end
local vec_math = function(func, ...) return __({...}):multi_map(func) end

local plumbing = {}

plumbing.vec_len = function(_) return math.sqrt(__(_):chain():map(sqrt):simple_reduce(add):value()) end

plumbing.normalize = function(_)
	local vec_len = plumbing.vec_len(_)
	return __(_):map(function(x) return div(x, vec_len) end)
end

plumbing.vec_add = function(...)
	return vec_math(multi_add, ...)
end

plumbing.vec_sub = function(...)
	return vec_math(multi_sub, ...)
end

plumbing.vec_smult = function(_, scalar)
	if type(_) ~= "table" then _, scalar = scalar, _ end  -- switches arguments in case of piping
	return __(_):map(__.curry(mult, scalar))
end

plumbing.vec_mult = function(...)
	return vec_math(multi_mult, ...)
end

plumbing.vec_div = function(...)
	return vec_math(multi_div, ...)
end

local wrap_for_piping = function(table)
	local wrapper = function(callback, this, ...)
			if this.output then
				this.output = callback(this.output, ...)
				return this
			end
			return callback(this, ...)
		end
	__(table_iterator(table)):each(function(pair) table[pair.key] = __.wrap(pair.value, wrapper) end)
end

return (function()
	local prototype = {unpack = function(self) return unpack(self.output) end}
	local meta = {}
	meta.__call = function(self, _)
		self.output = _
		return self
	end
	meta.__index = function(self, key)
		return plumbing[key]
	end
	wrap_for_piping(plumbing)
	return setmetatable(prototype, meta)
end)()