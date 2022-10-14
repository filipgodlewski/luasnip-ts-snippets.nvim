local l = require "luasnip.session".config.snip_env
local u = require "after.plugin.luasnip.utils"

local bodies = {
   boilerplate = [[
   local l = require "luasnip.session".config.snip_env
   local u = require "after.plugin.luasnip.utils"

   return { l.s({
      trig = "<>",
      name = "<>",
      dscr = "<>",
   }, <>) }
   ]],
   fmt = "l.fmt(<>, <>)",
   fmta = "l.fmta(<>, <>)",
}

local function snip_fmt(text, desc)
   return l.sn(nil, l.fmta(text, { l.i(1), l.i(2) }), u.desc(desc))
end

return {
   l.s({
      trig = "lsb",
      name = "luasnip boilerplate",
      dscr = "The base for all the luasnip snippets",
   }, l.fmta(bodies.boilerplate, {
      l.i(1), l.i(2), l.i(3), l.i(4)
   })),
   l.s({
      trig = "fmt",
      name = "luasnip fmt",
      dscr = "Interpolated string returning a table of nodes"
   }, l.c(1, {
      snip_fmt(bodies.fmta, "With <>"),
      snip_fmt(bodies.fmt, "With {}"),
   })),
}
