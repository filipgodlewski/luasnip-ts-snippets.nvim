local l = require "luasnip.session".config.snip_env

return {

   l.s({
      trig = "import",
      name = "import",
      dscr = "Import statement",
   }, l.fmta("import <module>", {
      module = l.i(1, "abc")
   })),

   l.s({
      trig = "from",
      name = "import from",
      dscr = "Import from module statement",
   }, l.fmta("from <module> import <object>", {
      module = l.i(1, "abc"),
      object = l.i(2, "ABC")
   }))

}
