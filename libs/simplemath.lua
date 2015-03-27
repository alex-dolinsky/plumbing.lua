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

local simplemath = {}

simplemath.add = function (x, y) return x + y end
simplemath.sub = function (x, y) return x - y end
simplemath.mult = function (x, y) return x * y end
simplemath.div = function (x, y) return x / y end
simplemath.sqr = function (x) return x * x end
local single_to_multi = function (func, ...) return __ ({...}) : simple_reduce (func) end
simplemath.single_to_multi = single_to_multi
simplemath.multi_add = function (...) return single_to_multi (simplemath.add, ...) end
simplemath.multi_sub = function (...) return single_to_multi (simplemath.sub, ...) end
simplemath.multi_mult = function (...) return single_to_multi (simplemath.mult, ...) end
simplemath.multi_div = function (...) return single_to_multi (simplemath.div, ...) end
simplemath.multi_sqr = function (...) return single_to_multi (simplemath.sqr, ...) end
simplemath.reciprocal = function (x) return 1.0 / x end

simplemath.even = function (x) return x % 2 == 0 end
simplemath.odd = __.negate (simplemath.even)

return simplemath