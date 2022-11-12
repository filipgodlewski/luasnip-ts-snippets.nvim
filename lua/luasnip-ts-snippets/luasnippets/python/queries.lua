local M = {}

M.fn = [[
(function_definition
   name: (identifier) @is_private (#match? @is_private "^_[a-zA-Z_]*$"))
(function_definition
   parameters: [
      (parameters (identifier) @param (#not-any-of? @param "self" "cls"))
      (parameters (default_parameter (identifier) @param))
      (parameters (typed_parameter (identifier) @param type: (type) @ptype))
      (parameters (typed_default_parameter (identifier) @param type: (type) @ptype))
      (parameters (list_splat_pattern (identifier) @param))
      (parameters (dictionary_splat_pattern (identifier) @param))
   ])
(function_definition
   return_type: (type) @retval)
]]

M.cls = [[
(class_definition
   name: (identifier) @cls_name)
]]

M.private_formatted = [[
(class_definition
  body: [
    (expression_statement (assignment left: (identifier) @name (#eq? @name "_%s")))
    (function_definition
      (body: (expression_statement (assignment left: (identifier) @name (#eq? @name "_%s")))))
  ])

(class_definition
  body: [
    (expression_statement (assignment type: (type) @atype))
    (function_definition
      (expression_statement (assignment type: (type) @atype)))
  ])
]]

return M
