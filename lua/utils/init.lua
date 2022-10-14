local M = {}

function M.in_array(array, item)
   for _, value in ipairs(array) do
      if value == item then return true end
   end
   return false
end

function M.i(item)
   print(vim.inspect(item))
end

return M
