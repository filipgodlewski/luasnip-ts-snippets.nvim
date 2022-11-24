local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"

local function last(index, sep)
   return l.f(function(name)
      local parts = vim.split(name[1][1], sep, true)
      return string.gsub(parts[#parts], "-", "_") or ""
   end, { index })
end

return {
   l.s(
      {
         trig = "require",
         name = "Import statement",
         dscr = "Require to a local variable",
      },
      l.c(1, {
         l.sn(nil, l.fmta('require("<>").<>', { l.i(1), l.i(2, "setup") }), u.desc "Normal"),
         l.sn(nil, l.fmta('local <> = require "<>"<>', { last(1, "."), l.i(1), l.i(2) }), u.desc "Import"),
      })
   ),
}
