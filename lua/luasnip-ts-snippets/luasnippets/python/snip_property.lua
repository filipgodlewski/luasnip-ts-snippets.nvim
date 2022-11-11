local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"
local py_utils = require "luasnip-ts-snippets.luasnippets.python.utils"

local function property_snip_node(desc, lookup_key)
   return l.sn(
      nil,
      l.fmta(py_utils.property_declarations[lookup_key], {
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
         property_snip_node("Property getter", "getter"),
         property_snip_node("Property getter+setter", "getter_setter"),
      })
   ),
}
