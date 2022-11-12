local isn = require("luasnip").indent_snippet_node
local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"
local nu = require "luasnip-ts-snippets.utils"
local ts_utils = require "luasnip-ts-snippets.utils.treesitter"
local py_queries = require "luasnip-ts-snippets.luasnippets.python.queries"
local ts = vim.treesitter

local function_declaration = [[
<decorator>
def <name>(<ref><params>) ->> <retval>:
    <docstring><body>
]]

local function param_parser(matches)
   local index = 2
   local lines = { '"""<>' }
   local line_nodes = { l.i(1, "...") }

   for _, match in matches do
      local is_private, param, ptype, retval = match[1], match[2], match[3], match[4]
      if is_private ~= nil then break end
      if param ~= nil then
         local args_header = "\nArgs:"
         if not nu.in_array(lines, args_header) then table.insert(lines, args_header) end
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
   return l.sn(
      nil,
      l.fmta(function_declaration, {
         decorator = l.t(decorator or ""),
         name = l.i(1, "foo"),
         ref = l.t(ref or ""),
         params = l.i(2),
         retval = l.i(3, "None"),
         docstring = l.d(
            4,
            function()
               return isn(
                  nil,
                  ts_utils.parse_matches(ts_utils.types.fn, param_parser, py_queries.fn, l.t "pass"),
                  "$PARENT_INDENT\t"
               )
            end,
            { 1, 2, 3 }
         ),
         body = isn(nil, { l.t { "", "" }, l.i(5, "pass") }, "$PARENT_INDENT\t"),
      }),
      u.desc(desc)
   )
end

local main_fn = [[
if __name__ == "__main__":
    <body>
]]

return {

   l.s(
      {
         trig = "def",
         name = "function definition",
         dscr = "Create a function",
      },
      l.c(1, {
         snip_node("Regular", nil, nil),
         snip_node("Method", nil, "self"),
         snip_node("Staticmethod", "@staticmethod", nil),
         snip_node("Classmethod", "@classmethod", "cls"),
      })
   ),

   l.s(
      {
         trig = "lambda",
         name = "Lambda function",
         dscr = "Create an anonymous function",
      },
      l.fmta("lambda <>: <>", {
         l.i(1, "x"),
         l.i(2, "x"),
      })
   ),

   l.s({
      trig = "main",
      name = "If name is main",
      dscr = "Create main function boilerplate",
   }, l.fmta(main_fn, { body = l.i(1, "main()") })),
}
