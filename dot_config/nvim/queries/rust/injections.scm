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

(
  (call_expression 
  (field_expression 
    (call_expression 
      (field_expression 
        (call_expression 
          (field_expression 
            (call_expression 
              (field_expression 
                value: (identifier) @struct (#eq? @struct "py")
                field: (field_identifier) @method (#eq? @method "eval_bound")) 
              (arguments 
                (string_literal 
                  (string_content) @injection.content (#set! injection.language "python")
                )
              )
            )
          )
        )
      )
    )
  )
 )
)

(
 (line_comment
   doc: (doc_comment) @injection.content
 ) 
 (#set! injection.language "markdown")
 (#set! injection.include-children)
)
