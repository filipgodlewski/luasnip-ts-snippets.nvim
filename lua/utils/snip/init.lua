local ls = require "luasnip"
local f = ls.function_node


local M = {}

-- repeat the node under given index
-- @param index integer of the node referred to
-- @return any whatever the node is supposed to copy
function M.copy(index)
   return f(function(arg)
      return arg[1]
   end, { index })
end

-- get last item after 'sep' in require function
-- @param index integer of the node referred to
-- @param sep string the split separator
-- @return string the last split item
function M.last_text(index, sep)
   return f(function(name)
      local parts = vim.split(name[1][1], sep, true)
      return parts[#parts] or ""
   end, { index })
end

-- set virt text description for nodes
-- @param text string wha you want to print to virt text
-- @return table containing opts for nodes
function M.desc(text)
   return {
      node_ext_opts = {
         active = {
            virt_text = { { text, "LuaSnipActiveChoice" } }
         }
      }
   }
end

return M
