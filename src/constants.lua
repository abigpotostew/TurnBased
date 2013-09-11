
local function protect_table (tbl)
  return setmetatable ({}, 
    {
    __index = tbl,  -- read access gets original table item
    __newindex = function (t, n, v)
       error ("attempting to change constant " .. 
             tostring (n) .. " to " .. tostring (v), 2)
      end -- __newindex 
    })

end -- function protect_table

local create = { protect_table = protect_table }

return create

-------------------------- test -----------------

-- const =
--   {
--   WIDTH = 22,
--   HEIGHT = 44,
--   FOO = "bar",
--   }
-- 
-- -- protect my table now
-- const = protect_table (const)

-- test it
--print ("WIDTH",  my_constants.WIDTH)  --> WIDTH 22
--print ("HEIGHT", my_constants.HEIGHT) --> HEIGHT 44

--my_constants.WIDTH = 44  --> Error: attempting to change constant WIDTH to 44