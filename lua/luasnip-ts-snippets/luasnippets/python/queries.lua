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
(class_definition body:
  (block [
    (function_definition
      name: (identifier) @fn_name (#eq? @fn_name "__init__")
      body: (block
        (expression_statement
          (assignment
            left: (attribute attribute: (identifier) @iname (#eq? @iname "_%s"))
            type: (type) @itype))))
    (expression_statement
      (assignment
        left: (identifier) @aname (#eq? @aname "_%s")
        type: (type) @atype))
  ]))
]]

return M
