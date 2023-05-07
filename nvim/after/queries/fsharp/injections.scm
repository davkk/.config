(infix_expression 
  (long_identifier_or_op
    (long_identifier (identifier) @id)
    (#eq? @id "query"))

  (const (triple_quoted_string) @graphql
         (#offset! @graphql 0 3 0 -3)))
