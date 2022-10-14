local l = require "luasnip.session".config.snip_env
local u = require "after.plugin.luasnip.utils"

return { l.s({
   trig = "i",
   name = "import",
   dscr = "Import statement",
}, l.c(1, {
   l.sn(nil, l.fmta("import <module>", { module = l.i(1, "abc") }), u.desc("Direct")),
   l.sn(nil, l.fmta("from <module> import <object>", { module = l.i(1, "__future__"), object = l.i(2, "annotations") }), u.desc("Filtered")),
})) }
