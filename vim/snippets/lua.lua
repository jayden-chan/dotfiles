---@diagnostic disable: undefined-global
return {
	s(
		"sn",
		fmt(
			[=[
s("{1}", fmt([[{2}]], {{{3}}}))
]=],
			{ i(1), i(2), i(0) }
		)
	),
}
