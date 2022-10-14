local l = require "luasnip.session".config.snip_env
local u = require "after.plugin.luasnip.utils"

local bodies = {
   default = [[
   local <name> = {}

   <body>

   return <rep>
   ]],

   class = [[
   local <name> = {}
   <rep>.__index = <rep>

   function <rep>:new()
      return setmetatable({}, <rep>)
   end
   <body>
   return <rep>
   ]]
}

local function snip_node(text, desc)
   return l.sn(nil, l.fmta(text, { name = l.i(1, "M"), body = l.i(2), rep = l.rep(1), }), desc)
end

return { l.s({
   trig = "m",
   name = "Module boilerplate",
   dscr = "Choose between a default module and a class representation",
}, l.c(1, {
   snip_node(bodies.default, u.desc("Default")),
   snip_node(bodies.class, u.desc("Class")),
})) }
