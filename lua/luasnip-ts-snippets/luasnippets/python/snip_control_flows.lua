local l = require("luasnip.session").config.snip_env
local u = require "luasnip-ts-snippets.utils.snip"

local bodies = {
   if_regular = [[
   if <if_condition>:
       <if_body>
   ]],
   if_else = [[
   if <if_condition>:
       <if_body>
   else:
       <else_body>
   ]],
   if_elif_else = [[
   if <if_condition>:
       <if_body>
   elif <elif_condition>:
       <elif_body>
   else:
       <else_body>
   ]],
   for_in = [[
   for <element> in <elements>:
       <body>
   ]],
   while_loop = [[
   while <condition>:
       <body>
   ]],
   while_true = [[
   while True:
       if <condition>:
          break
       <body>
   ]],
   while_increments = [[
   i = 0
   while i << <condition>:
       <body>
       i += 1
   ]],
}

local function snip_node(desc, text, nodes) return l.sn(nil, l.fmta(text, nodes), u.desc(desc)) end

return {

   l.s(
      {
         trig = "if",
         name = "if statement",
         dscr = "Create an if statement",
      },
      l.c(1, {
         snip_node("If", bodies.if_regular, {
            if_condition = l.i(1, "True"),
            if_body = l.i(2, "pass"),
         }),

         snip_node("If/else", bodies.if_else, {
            if_condition = l.i(1, "True"),
            if_body = l.i(2, "pass"),
            else_body = l.i(3, "pass"),
         }),

         snip_node("If/elif/else", bodies.if_elif_else, {
            if_condition = l.i(1, "True"),
            if_body = l.i(2, "pass"),
            elif_condition = l.i(3, "False"),
            elif_body = l.i(4, "pass"),
            else_body = l.i(5, "pass"),
         }),
      })
   ),

   l.s(
      {
         trig = "for",
         name = "for in statement",
         dscr = "Create a for in statement",
      },
      l.fmta(bodies.for_in, {
         element = l.i(2, "element"),
         elements = l.i(1, "elements"),
         body = l.i(3, "pass"),
      })
   ),

   l.s(
      {
         trig = "while",
         name = "while statement",
         dscr = "Create a while loop",
      },
      l.c(1, {
         snip_node("While", bodies.while_loop, {
            condition = l.i(1, "condition"),
            body = l.i(2, "pass"),
         }),
         snip_node("While True", bodies.while_true, {
            condition = l.i(1, "condition"),
            body = l.i(2, "pass"),
         }),
         snip_node("While incremented", bodies.while_increments, {
            condition = l.i(1, "value"),
            body = l.i(2, "pass"),
         }),
      })
   ),
}
