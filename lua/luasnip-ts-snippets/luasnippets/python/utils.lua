local M = {}

M.function_query = [[
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

M.class_query = [[
(class_definition
   name: (identifier) @cls_name)
]]

M.function_declaration = [[
<decorator>
def <name>(<ref><params>) ->> <retval>:
    <docstring><body>
]]

M.property_declarations = {
   getter = [[
   @property
   def <name>(self) ->> <retval>:
       <getter_body>
   ]],
   getter_setter = [[
   @property
   def <name>(self) ->> <retval>:
       <getter_body>

   @<rep>.setter
   def <rep>(self, <value>: <value_type>) ->> None:
       <setter_body>
   ]],
}

return M
