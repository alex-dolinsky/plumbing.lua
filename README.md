# plumbing.lua
plumbing.lua is a multi-purpose library that incorporates easy input-output chaining (piping).

At the moment only raw vector operations are supported, more will follow in time.


###### single vector operations

- vec_len : returns a scalar, the vector's length.
- normalize : returns a normalized vector.
- unpack : a multiple return of every member in a vector.

###### single vector and a scalar operations

- vec_smult : returns a vector multiplied by a scalar, the order of arguments is irrelevant.

###### multiple vector operations, *each of these returns a single vector*

- vec_add : a sum
- vec_sub : a difference
- vec_mult : a product
- vec_div : a quotient


#### Usage

plumbing({1, 2, 3}):vec_add({9, 2, 3}, {5, 3, 1}):vec_smult(7):normalize():unpack() or .ouput
