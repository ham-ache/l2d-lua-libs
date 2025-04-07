# hamache's Random Lua Stuff

## autoreset.lua
**setResetter**(<sup>table</sup> table, <sup>table</sup> cache, <sup>string</sup> cachename, <sup>number or nil</sup> valdefault)[void]
- a function which creates/wraps a metatable with __newindex for resetting values every time the table has changed
## opairs.lua [dependent: autoreset.lua]
**opairs**(<sup>table</sup> table, <sup>bool</sup> sort alphabetically)[<sup>func</sup> iterator]
- sorts table by manual order / alphabet order, caches results
  
**changeOrder**(<sup>table</sup> table, <sup>any</sup> key, <sup>any</sup> new)[void]
- changes order and triggers sort cache update
## table_operations.lua
**table.copy**(<sup>table</sup> table)[void]
- creates a copy of a table

**table.isarr**(<sup>table</sup> table)[<sup>bool</sup> result]
- is table an array?

**table.union**(<sup>table</sup> first, <sup>table</sup> second)[<sup>table</sup> result]
- set union

**table.diff**(<sup>table</sup> first, <sup>table</sup> second)[<sup>table</sup> result]
- set difference

**table.intersect**(<sup>table</sup> first, <sup>table</sup> second)[<sup>table</sup> result]
- set intersection

## LOVE2D : ssys.lua
**ssys.new**(<sup>string</sup> scene name, <sup>string</sup> love2d callback, <sup>func</sup> function, <sup>number or nil</sup> order)[void]
- creates a new callback at its own order (order is 0 by default)

**ssys.call**(<sup>string</sup> callback, <sup>...</sup> any arguments)[void]
- creates a new callback if there is not, and calls it

ssys replaces love2d callbacks

## LOVE2D GLSL shader : dither.lua
uniform <sup>float</sup> split 
- pixel scale

uniform <sup>vec3</sup> palette
- 1-bit palette

## LOVE2D GLSL shader : clouds.lua
uniform <sup>float</sup> time
- in-game time

uniform <sup>seed</sup> seed
- first random seed

uniform <sup>vec2</sup> bgOffset
- offset the clouds towards the vec2

uniform <sup>float</sup> tmult
- time multiplier. will be removed.
