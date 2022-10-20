local l = require "luasnip.session".config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"

return {
   l.s({
      trig = "require",
      name = "Import statement",
      dscr = "Require to a local variable"
   }, l.fmt('local {} = require "{}"{}', {
      u.last_text(1, "."),
      l.i(1),
      l.i(2)
   }))
}
