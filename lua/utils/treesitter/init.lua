local ts = vim.treesitter
local tsu = require "nvim-treesitter.ts_utils"
local tsl = require "nvim-treesitter.locals"
local nu = require "after.nvim_utils"
local l = require "luasnip.session".config.snip_env

local M = {}
M.function_types = { "function_definition", "function_declaration" }

function M.refresh_syntax_tree()
   ts.get_parser(0):parse()
end

function M.get_root_node(lookup_array)
   for scope in tsl.iter_scope_tree(tsu.get_node_at_cursor(), 0) do
      if nu.in_array(lookup_array, scope:type()) then return scope end
   end
end

-- M.parse_matches
-- @param lines_parser { function } a function that takes 1 arg:
-- - captures { any } iterator for the captured nodes
-- It also must return 2 items:
-- - string containing the whole interpolation string used by luasnip`s fmta()
--   which means that for the interpolation it uses '<>' instead of '{}'
-- - table containing interpolation nodes to be parsed by luasnip's fmta()
-- @param query { string } the query that should return matches
-- @return snippet node with the whole docstring
function M.parse_matches(lookup_array, lines_parser, query, fallback)
   M.refresh_syntax_tree()
   local root = M.get_root_node(lookup_array)
   if not root then return fallback end

   local matches = ts.parse_query(vim.bo.filetype, query):iter_matches(root, 0)
   local lines, nodes = lines_parser(matches)
   if #nodes == 0 then return fallback end

   return l.fmta(lines, nodes)
end


return M
