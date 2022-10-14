local ls  = require "luasnip"
local s   = ls.snippet
local isn = ls.indent_snippet_node
local t   = ls.text_node
local i   = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {
   -- TODO: if/else/elif/ifelse/ifelifelse
   -- TODO: list, generator, dict, set comprehensions
   -- TODO: treesitter-aware docstring
   -- TODO: try/except, try/finally, try/except/finally
   -- TODO: with
   s("l", { t "lambda ", i(1, "x"), t ": ", i(2, "x") }),
   s("m", { t({ 'if __name__ == "__main__":', "\t" }), isn(1, i(1, "main()"), "$PARENT_INDENT\t") }),
   s("s", fmt("super().{}", { i(1) })),
}

ls.add_snippets("python", snippets)
