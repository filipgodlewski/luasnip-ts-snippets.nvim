local isn = require "luasnip".indent_snippet_node
local l = require "luasnip.session".config.snip_env
local u = require "after.plugin.luasnip.utils"
local nu = require "after.nvim_utils"
local ts_utils = require "after.plugin.luasnip.ts_utils"
local py_utils = require "after.plugin.luasnip.luasnippets.python.utils"
local ts = vim.treesitter

local function param_parser(matches)
   local index = 2
   local lines = { '"""<>' }
   local line_nodes = { l.i(1, "...") }

   for _, match in matches do
      local is_private, param, ptype, retval = match[1], match[2], match[3], match[4]
      if is_private ~= nil then break end
      if param ~= nil then
         local args_header = "\nArgs:"
         if not nu.in_array(lines, args_header) then
            table.insert(lines, args_header)
         end
         local name = ts.query.get_node_text(param, 0)
         local type = ptype == nil and "Any" or ts.query.get_node_text(ptype, 0)
         table.insert(lines, string.format("\t%s (%s): <>", name, type))
         table.insert(line_nodes, l.i(index, "..."))
      else
         table.insert(lines, "\nReturns:")
         table.insert(lines, string.format("\t%s: <>", ts.query.get_node_text(retval, 0)))
         table.insert(line_nodes, l.i(index, "..."))
      end
      index = index + 1
   end

   lines[#lines] = lines[#lines] .. (#lines == 1 and '"""' or '\n"""')
   return table.concat(lines, "\n"), line_nodes
end

local function snip_node(desc, decorator, ref)
   return l.sn(nil, l.fmta(py_utils.function_declaration, {
      decorator = l.t(decorator or ""),
      name = l.i(1, "foo"),
      ref = l.t(ref or ""),
      params = l.i(2),
      retval = l.i(3, "None"),
      docstring = l.d(4, function()
         return isn(nil, ts_utils.parse_matches(ts_utils.function_types, param_parser, py_utils.function_query, l.t "pass"), "$PARENT_INDENT\t")
      end, { 1, 2, 3 }),
      body = isn(nil, {l.t {"", ""}, l.i(5, "pass")}, "$PARENT_INDENT\t"),
   }), u.desc(desc))
end

return { l.s({
   trig = "d",
   name = "Function definition",
   dscr = "Create a function",
}, l.c(1, {
   snip_node("Regular", nil, nil),
   snip_node("Method", nil, "self"),
   snip_node("Property getter", "@property", "self"),
   snip_node("Staticmethod", "@staticmethod", nil),
   snip_node("Classmethod", "@classmethod", "cls"),
})) }
