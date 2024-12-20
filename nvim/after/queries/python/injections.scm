; extends

((
  (comment) @_mdcomment
  . (expression_statement
      (string (string_content) @injection.content)))
  (#lua-match? @_mdcomment "^# %%%% %[markdown%]")
  (#set! injection.language "markdown"))
