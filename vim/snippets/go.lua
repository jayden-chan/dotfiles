---@diagnostic disable: undefined-global
return {
	s("pf", fmt("fmt.Printf({})", i(0))),
	s("pl", fmt("fmt.Println({})", i(0))),
	s("log", fmt("fmt.Println({})", i(0))),
	s("ep", fmt("fmt.Fprintln(os.Stderr, {})", i(0))),
	s("ef", fmt("fmt.Fprintf(os.Stderr, {})", i(0))),
	s("lf", fmt("log.Printf({})", i(0))),
	s("ln", fmt("log.Println({})", i(0))),
	s(
		"for",
		fmt(
			[[
for {1} := {2}; {1} < {3}; {1}++ {{
	{4}
}}
]],
			{ i(1), i(2), i(3), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"forr",
		fmt(
			[[
for {1} := {2}; {1} > {3}; {1}-- {{
	{4}
}}
]],
			{ i(1), i(2), i(3), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"fore",
		fmt(
			[[
for {1}, {2} := range {3} {{
	{4}
}}
]],
			{ i(1), i(2), i(3), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"func",
		fmt(
			[[
// {1}
func {1}({2}) {3}{{
	{4}
}}
]],
			{ i(1), i(2), i(3), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"err",
		t({
			"if err != nil {",
			"\treturn err",
			"}",
		})
	),
	s(
		"meth",
		fmt(
			[[
// {2}
func ({1}) {2}({3}) {4}{{
	{5}
}}
]],
			{ i(1), i(2), i(3), i(4), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"gof",
		fmt(
			[[
go func({1}) {{
	{2}
}}()
]],
			{ i(1), i(0) }
		)
	),
}
