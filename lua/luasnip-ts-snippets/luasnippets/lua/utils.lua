local M = {}

M.function_query = [[
;; query
[
   (function_definition parameters: (parameters (identifier) @param))
   (function_declaration parameters: (parameters (identifier) @param))
]
]]

return M
