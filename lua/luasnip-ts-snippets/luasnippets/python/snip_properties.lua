local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"
local nu = require "luasnip-ts-snippets.utils"
local ts_utils = require "luasnip-ts-snippets.utils.treesitter"
local py_queries = require "luasnip-ts-snippets.luasnippets.python.queries"

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

local function priv_attr_parser(matches) end

local function priv_attr_type_parser(matches)
   nu.i(matches)
   for _, match in matches do
      nu.i(match)
   end
   return "%s", l.i(1, "None")
end

local function snip_node(desc, lookup_key)
   return l.sn(
      nil,
      l.fmta(declarations[lookup_key], {
         name = l.i(1, "foo"), -- TODO: add node remembering on switch
         retval = l.d(2, function(args)
            local name = args[1][1]
            return l.sn(
               nil,
               ts_utils.parse_matches(
                  ts_utils.types.cls,
                  priv_attr_type_parser,
                  py_queries.private_formatted,
                  l.i "Any",
                  name,
                  name
               )
            )
         end, { 1 }),
         getter_body = l.d(3, function(args)
            local name = args[1][1] -- TODO: If can't locate _foo in class, then 'return '
            return l.sn(nil, l.i(1, string.format("return self._%s", name)))
         end, { 1 }),
         rep = l.rep(1),
         value = l.i(4, "value"),
         value_type = l.i(5, "Any"),
         setter_body = l.d(6, function(args)
            local name = args[1][1]
            local value = args[2][1]
            return l.sn(nil, l.i(1, string.format("self._%s = %s", name, value)))
         end, { 1, 4 }),
         deleter_body = l.d(7, function(args)
            local name = args[1][1] -- TODO: If can't locate _foo in class, then 'return '
            return l.sn(nil, l.i(1, string.format("del self._%s", name)))
         end, { 1 }),
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
