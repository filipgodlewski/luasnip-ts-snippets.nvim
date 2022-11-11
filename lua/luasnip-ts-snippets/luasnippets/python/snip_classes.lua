local isn = require("luasnip").indent_snippet_node
local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"
local nu = require "luasnip-ts-snippets.utils"
local ts_utils = require "luasnip-ts-snippets.utils.treesitter"
local py_queries = require "luasnip-ts-snippets.luasnippets.python.queries"
local ts = vim.treesitter

local declarations = {
   cls = [[
class <name><inheritance>:
    <body>
]],
   init = [[
def __init__(self<params>) ->> None:
    <body>
]],
}

local function param_parser(matches)
   local index = 1
   local lines = {}
   local line_nodes = {}

   for _, match in matches do
      nu.i(match)
      local param, ptype = match[2], match[3]
      if param ~= nil then
         local name = ts.query.get_node_text(param, 0)
         local type = ptype == nil and "Any" or ts.query.get_node_text(ptype, 0)
         table.insert(lines, string.format("self.<>: %s = %s", type, name))
         table.insert(line_nodes, l.i(index, name))
      end
      index = index + 1
   end

   table.insert(lines, "super().__init__()")
   return table.concat(lines, "\n"), line_nodes
end

local function setup_init(pos)
   return l.sn(
      pos,
      l.fmta(declarations.init, {
         params = l.i(1), -- TODO: get params of superclass
         body = l.d(2, function()
            return l.sn(
               nil,
               ts_utils.parse_matches(
                  ts_utils.types.fn,
                  param_parser,
                  py_queries.fn,
                  l.t "super().__init__()" -- TODO: get init of superclass
               )
            )
         end, { 1 }),
      })
   )
end

local function snip_node(desc, has_init)
   return l.sn(
      nil,
      l.fmta(declarations.cls, {
         name = l.i(1, "Foo"),
         inheritance = l.i(2),
         body = has_init and setup_init(3) or l.i(3, "pass"),
      }),
      u.desc(desc)
   )
end

return {

   l.s(
      {
         trig = "class",
         name = "Class constructor",
         dscr = "Create a class",
      },
      l.c(1, {
         snip_node("With initializer", true),
         snip_node("No __init__", false),
      })
   ),

   l.s(
      {
         trig = "super",
         name = "Super class call",
         dscr = "Call super class function",
      },
      l.fmta("super().<method>", {
         method = l.i(1, "__init__()"),
      })
   ),

   l.s(
      {
         trig = ".",
         name = "instance reference",
         dscr = "Shortcut for accessing an instance member",
      },
      l.fmta("self.<member>", {
         member = l.i(1),
      })
   ),
}
