(
    (
        (template_string) @_template_string
            (#match? @_template_string "^`\\s*\\<")
    ) @html

    (#offset! @html 0 1 0 -1)
)
