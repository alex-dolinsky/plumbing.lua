# plumbing.lua
plumbing.lua is a multi-purpose library that incorporates
easy input-output chaining (piping). As an example it makes vector operations a lot more readable.
At the moment only raw vector operations are supported, more will follow in time.
Uses and is heavily inspired by underscore.lua through a fork that I made,
get it here: https://github.com/alex-dolinsky/underscore.lua


###### single vector operations

- vec_len : returns a scalar, the vector's length.
- normalize : returns a normalized vector.
- vec_id : returns a copy of a vector, which is a different object that contains the same members (shallow copy).
- vec_ord_perm : returns ordered permutations for a vector as a vector. Example: {1,2,3} => {{1,2,3}, {3,1,2}, {2,3,1}}

###### single vector and a scalar operations

- vec_smult : returns a vector multiplied by a scalar, the order of arguments is irrelevant.

###### multiple vector operations, *each of these returns a single vector*

- vec_add : a sum
- vec_sub : a difference
- vec_mult : a product
- vec_div : a quotient
- vec_cart_prod : returns a Cartesian product of multiple vectors as a vector. Example: {1,2}, {3,4}, {5,6} =>
{{1,3,5}, {1,3,6}, {1,4,5}, {1,4,6}, {2,3,5}, {2,3,6}, {2,4,5}, {2,4,6}}

###### utility operations, only in piping!
- unpack : a multiple return of every member in a vector.

#### Usage

- piping: plumbing ({1,2,3}) : vec_add ({9,2,3}, {5,3,1}) : vec_smult (7) : normalize () : unpack () or .output
- functional: plumbing.vec_add ({9,2,3}, {5,3,1})
- a cool MOAI/Hanappe example: body:setLinearVelocity(plumbing ({layer : wndToWorld (event.x, event.y)}) : vec_sub ({body  : getPos ()}) : normalize() : vec_smult (speed) : unpack())


## Links
- MOAI: http://getmoai.com 
- MOAI github: https://github.com/moai
- Hanappe github: https://github.com/makotok/Hanappe
