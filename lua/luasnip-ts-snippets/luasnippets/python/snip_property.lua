local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"

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
}

local function snip_node(desc, lookup_key)
   return l.sn(
      nil,
      l.fmta(declarations[lookup_key], {
         name = l.i(1, "foo"), -- TODO: add node remembering on switch
         retval = l.i(2, "Any"), -- TODO: If possible, take type of _foo, else Any
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
      })
   ),
}
