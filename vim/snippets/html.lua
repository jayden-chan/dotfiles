---@diagnostic disable: undefined-global
return {
	s(
		"start",
		fmt(
			[[
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8"/>

		<title>Title</title>
		<meta name="author" content="Author"/>
	</head>

	<body>
	</body>
</html>
]],
			{}
		)
	),
	s(
		"<>",
		fmt(
			[[
<{1}>
	{2}
</{1}>
]],
			{ i(1), i(0) },
			{ repeat_duplicates = true }
		)
	),
}
