local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"
local ts_utils = require "luasnip-ts-snippets.utils.treesitter"
local py_queries = require "luasnip-ts-snippets.luasnippets.python.queries"
local ts = vim.treesitter

local declarations = {
   getter = [[
   @property
   def <name>(self) ->> <retval>:
       <getter_body>
   ]],
   getter_setter = [[
   @property
   def <name>(self) ->> <retval>:
       <getter_body>

   @<rep>.setter
   def <rep>(self, <value>: <value_type>) ->> None:
       <setter_body>
   ]],
   getter_setter_deleter = [[
   @property
   def <name>(self) ->> <retval>:
       <getter_body>

   @<rep>.setter
   def <rep>(self, <value>: <value_type>) ->> None:
       <setter_body>

   @<rep>.deleter
   def <rep>(self) ->> None:
       <deleter_body>
   ]],
}

local function type_parser(matches)
   local atype = "Any"
   for _, match in matches do
      atype = ts.get_node_text(match[3] or match[5], 0)
      break
   end
   return "<>", { l.i(1, atype) }
end

local function name_parser(matches)
   local retval = "return "
   local aname
   for _, match in matches do
      aname = ts.get_node_text(match[2] or match[4], 0)
      break
   end
   return "<>", { l.i(1, aname ~= nil and (retval .. "self." .. aname) or retval) }
end

local function parse_priv(args, parser, fallback)
   local name = args[1][1]
   return l.sn(
      nil,
      ts_utils.parse_matches(ts_utils.types.cls, parser, py_queries.private_formatted, fallback, { name, name })
   )
end

local function parse_type(args) return parse_priv(args, type_parser, l.i(1, "Any")) end
local function parse_name(args) return parse_priv(args, name_parser, l.i(1, "return")) end

local function snip_node(desc, lookup_key)
   return l.sn(
      nil,
      l.fmta(declarations[lookup_key], {
         name = l.i(1),
         retval = l.d(2, parse_type, { 1 }),
         getter_body = l.d(3, parse_name, { 1 }),
         rep = l.rep(1),
         value = l.i(4, "value"),
         value_type = l.d(5, parse_type, { 1 }),
         setter_body = l.d(6, function(args)
            local name = args[1][1]
            local value = args[2][1]
            return l.sn(nil, l.i(1, string.format("self._%s = %s", name, value)))
         end, { 1, 4 }),
         deleter_body = l.d(7, parse_name, { 1 }),
      }, { strict = false }),
      u.desc(desc)
   )
end

return {

   l.s(
      {
         trig = "property",
         name = "Property boilerplate",
         dscr = "Create new property",
      },
      l.c(1, {
         snip_node("Property getter", "getter"),
         snip_node("Property getter+setter", "getter_setter"),
         snip_node("Property getter+setter+deleter", "getter_setter_deleter"),
      })
   ),
}
