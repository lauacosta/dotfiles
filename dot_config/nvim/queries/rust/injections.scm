(
      (call_expression
        (scoped_identifier
          path: (identifier) @module
          name: (identifier) @function)
        (arguments
          (string_literal
            (string_content) @injection.content)))
  (#eq? @module "sqlx")
  (#eq? @function "query_scalar")
  (#set! injection.language "sql")
)

(
  (call_expression
    (field_expression
      value: (identifier)
      field: (field_identifier) @function)
    (arguments
      (string_literal
        (string_content) @injection.content)))
  (#match? @function "^prepare(_cached)?$")
  (#set! injection.language "sql")
)

(
  (call_expression
    (field_expression
      value: (identifier)
      field: (field_identifier) @function)
    (arguments
      (reference_expression
        (macro_invocation
          macro: (identifier) @macro_name
          (token_tree
            (string_literal
              (string_content) @injection.content))))))
  (#match? @function "^prepare(_cached)?$")
  (#eq? @macro_name "format")
  (#set! injection.language "sql")
)


(
  (call_expression
    (scoped_identifier
      path: (identifier) @module
      name: (identifier) @function)
    (arguments
      (string_literal
        (string_content) @injection.content)))
  (#eq? @module "sqlx")
  (#eq? @function "query")
  (#set! injection.language "sql")
)

(
 (call_expression
  (scoped_identifier
    path: (identifier) @module
    name: (identifier) @function)
  (arguments
    (string_literal
      (string_content) @injection.content)
  )
 )
  (#eq? @module "sqlx")
  (#eq? @function "query_as")
  (#set! injection.language "sql")
)

(
 (macro_invocation
  (scoped_identifier
      path: (identifier) @module (#eq? @module "sqlx")
      name: (identifier) @macro_name) (#eq? @macro_name "query")
  (token_tree
    (raw_string_literal
      (string_content) @injection.content (#set! injection.language "sql")
    )
  )
 )
)


(
 (macro_invocation 
  (scoped_identifier 
  path: (identifier) @module (#eq? @module "sqlx")
  name: (identifier) @macro_name) (#eq? @macro_name "query_as") 
  (token_tree 
      (identifier) 
      (string_literal 
        (string_content) @injection.content  (#set! injection.language "sql")
      )
  )
  )
)

