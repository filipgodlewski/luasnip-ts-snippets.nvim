local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"
local ts_utils = require "luasnip-ts-snippets.utils.treesitter"
local lua_utils = require "luasnip-ts-snippets.luasnippets.lua.utils"
local ts = vim.treesitter

local bodies = {
   regular = [[
   -- <rep> <description><param_docs>
   <locality>function <name>(<params>)
      <body>
   end
   ]],
   anonymous = [[
   function(<params>)
      <body>
   end
   ]],
   one_liner = "function(<params>) <body> end",
}

local function param_parser(matches)
   local line_nodes = {}
   local index = 1
   local lines = {}

   for _, match in matches do
      if match[1] == nil then return "", {} end
      local param_name = ts.get_node_text(match[1], 0)
      local line = string.format("-- @param %s { <> } <>", param_name)
      table.insert(lines, line)
      table.insert(line_nodes, l.i(index, "any"))
      table.insert(line_nodes, l.i(index + 1, "..."))
      index = index + 2
   end

   table.insert(lines, 1, "\n")
   return table.concat(lines, "\n"), line_nodes
end

local function snip_node(text, desc, has_name, is_local)
   return l.sn(
      nil,
      l.fmta(text, {
         locality = is_local and l.t "local " or l.t "",
         name = l.i(1, "foo"),
         rep = l.rep(1),
         params = has_name and l.i(2) or l.i(1),
         description = l.i(3, "..."),
         param_docs = l.d(
            4,
            function()
               return l.sn(
                  nil,
                  ts_utils.parse_matches(ts_utils.types.fn, param_parser, lua_utils.function_query, l.t "")
               )
            end,
            has_name and 2 or 1
         ),
         body = has_name and l.i(5) or l.i(2),
      }, { strict = false }),
      u.desc(desc)
   )
end

return {
   l.s(
      {
         trig = "function",
         name = "function definition",
         dscr = "The boilerplate for different types of functions",
      },
      l.c(1, {
         snip_node(bodies.one_liner, "One-liner", false, false),
         snip_node(bodies.anonymous, "Anonymous", false, false),
         snip_node(bodies.regular, "Global", true, false),
         snip_node(bodies.regular, "Local", true, true),
      })
   ),
}
