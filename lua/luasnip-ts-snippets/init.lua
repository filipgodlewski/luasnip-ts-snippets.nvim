local ls = require "luasnip"
local M = {}

local snippets_path = "lua/luasnip-ts-snippets/luasnippets/"
local module_path = "luasnip-ts-snippets.luasnippets."

M.default_cfg = {
   filetypes = {
      "python",
      "lua",
   },
}

function M.setup(opts)
   opts = vim.tbl_deep_extend("force", M.default_cfg, opts or {})
   for _, ft in ipairs(opts.filetypes) do
      local file_paths = vim.api.nvim_get_runtime_file(snippets_path .. ft .. "/snip_*.lua", true)
      for _, path in ipairs(file_paths) do
         local file_name = path:match("^.*/(.+)%.lua$")
         ls.add_snippets(ft, require(module_path .. ft .. "." .. file_name))
      end
   end
end

return M
