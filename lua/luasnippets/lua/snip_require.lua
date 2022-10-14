local l = require "luasnip.session".config.snip_env
local u = require "after.plugin.luasnip.utils"

return { l.s({
   trig = "r",
   name = "Import statement",
   dscr = "Require to a local variable"
}, l.fmt('local {} = require "{}"{}', {
   u.last_text(1, "."),
   l.i(1),
   l.i(2)
})) }
