local isn = require "luasnip".indent_snippet_node
local l = require "luasnip.session".config.snip_env
local u = require "after.plugin.luasnip.utils"
local nu = require "after.nvim_utils"
local ts_utils = require "after.plugin.luasnip.ts_utils"
local py_utils = require "after.plugin.luasnip.luasnippets.python.utils"
local ts = vim.treesitter

local class_declaration = [[
class <name><inheritance>:
    <body>
]]

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
   return isn(pos, l.fmta(py_utils.function_declaration, {
      decorator = l.t "",
      name = l.t "__init__",
      ref = l.t "self",
      params = l.i(1),
      retval = l.t "None",
      docstring = l.t "",
      body = l.d(2, function()
         return isn(nil,
            ts_utils.parse_matches(
               ts_utils.function_types,
               param_parser,
               py_utils.function_query,
               l.t "super().__init__()" -- TODO: get init of superclass
            ),
            "$PARENT_INDENT\t"
         )
      end, { 1 }),
   }), "$PARENT_INDENT\t")
end

local function snip_node(desc, has_init)
   return l.sn(nil, l.fmta(class_declaration, {
      name = l.i(1, "Foo"),
      inheritance = l.i(2),
      body = has_init and setup_init(3) or l.i(3, "pass")
   }), u.desc(desc))
end

return { l.s({
   trig = "c",
   name = "Class constructor",
   dscr = "Create a class",
}, l.c(1, {
   snip_node("With initializer", true),
   snip_node("No __init__", false),
})) }
