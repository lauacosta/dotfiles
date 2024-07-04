(
  (call_expression
    function: (field_expression
      value: (call_expression
        function: (scoped_identifier
          path: (identifier) @module
          name: (identifier) @function)
        arguments: (arguments
          (string_literal
            (string_content) @injection.content)))))
  (#eq? @module "sqlx")
  (#eq? @function "query_scalar")
  (#set! injection.language "sql")
)

(
  (call_expression
    function: (field_expression
      value: (call_expression
        function: (scoped_identifier
          path: (identifier) @module
          name: (identifier) @function)
        arguments: (arguments
          (string_literal
            (string_content) @injection.content)))))
  (#eq? @module "sqlx")
  (#eq? @function "query")
  (#set! injection.language "sql")
)

(
 (call_expression
   function: (field_expression
        value: (macro_invocation
            macro: (scoped_identifier
                path: (identifier) @module
                name: (identifier) @macro_name)
            (token_tree
              (string_literal
                (string_content) @injection.content)))))
  (#eq? @module "sqlx")
  (#eq? @macro_name "query")
  (#set! injection.language "sql")
)
