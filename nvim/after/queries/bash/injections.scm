;; extends

(command
  name: (command_name (word) @_command)
  argument: (raw_string) @injection.content
     (#match? @_command "^[gnm]?awk$")
     (#set! injection.language "awk"))

(command
  name: (command_name (word) @_command)
  argument: (string) @injection.content
     (#match? @_command "^[gnm]?awk$")
     (#set! injection.language "awk"))

(command
  (word) @_name (#eq? @_name "awk")
  (raw_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "awk"))

(command
  (word) @_name (#eq? @_name "awk")
  (string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "awk"))
