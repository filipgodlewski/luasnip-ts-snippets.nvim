local l = require "luasnip.session".config.snip_env
local u = require "after.plugin.luasnip.utils"

return { l.s({
   trig = "v",
   name = "variable",
   dscr = "Either local or global variable",
}, l.fmta("<> = <>", {
   l.c(1, {
      l.sn(nil, l.fmta("local <>", { l.i(1) }), u.desc("local variable")),
      l.sn(nil, l.i(1), u.desc("global variable")),
   }),
   l.i(2),
})) }
