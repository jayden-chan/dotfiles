; Highlight sqlx::query!() and sqlx::query_as!() as SQL
(macro_invocation
    (scoped_identifier
        path: (identifier) @_path (#eq? @_path "sqlx")
        name: (identifier) @_name (#any-of? @_name "query" "query_as")
    )

    (token_tree
        (raw_string_literal) @sql
    )

    (#offset! @sql 0 3 0 -2)
)
