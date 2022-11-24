local cfg = require("luasnip-ts-snippets").cfg
local ls = require "luasnip"

local M = {}

-- set virt text description for nodes
-- @param text string wha you want to print to virt text
-- @return table containing opts for nodes
function M.desc(text)
   return {
      node_ext_opts = {
         active = {
            virt_text = { { text, cfg.active_choice_highlight_group } },
         },
      },
   }
end

return M
