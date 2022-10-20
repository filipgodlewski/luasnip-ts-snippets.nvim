local l = require "luasnip.session".config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"

return {
   l.s({
      trig = "var",
      name = "variable",
      dscr = "Either local or global variable",
   }, l.fmta("<> = <>", {
      l.c(1, {
         l.sn(nil, l.fmta("local <>", { l.i(1) }), u.desc("local variable")),
         l.sn(nil, l.i(1), u.desc("global variable")),
      }),
      l.i(2),
   }))
}
