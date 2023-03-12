return {
	s("log", fmt("console.log({})", i(0))),
	s("er", fmt("console.error({})", i(0))),
	s("deb", fmt("logger.debug({})", i(0))),
	s("info", fmt("logger.info({})", i(0))),
	s("warn", fmt("logger.warn({})", i(0))),
	s("err", fmt("logger.error({})", i(0))),
	s(
		"prom",
		fmt(
			[[
new Promise((resolve, reject) => {{
	{1}
}})
]],
			{ i(0) }
		)
	),
	s(
		"for",
		fmt(
			[[
for(let {1} = {2}; {1} < {3}; {1}++) {{
	{4}
}}
]],
			{ i(1), i(2), i(3), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"main",
		fmt(
			[[
{1}function main() {{
	{2}
}}
]],
			{ c(1, { t(""), t("async ") }), i(0) }
		)
	),
	s(
		"try",
		fmt(
			[[
try {{
	{1}
}} catch (e) {{{2}}}
]],
			{ i(1), i(0) }
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
	s(
		"react",
		fmt(
			[[
export const {1} = (props: {{}}) => {{
	return (
		<div>
			{2}
		</div>
	)
}};
]],
			{ i(1), i(0) }
		)
	),
	s(
		"st",
		fmt(
			[[
const [{1}, set{2}] = useState({3});
]],
			{ i(1), f(function(args)
				return args[1][1]:gsub("^%l", string.upper)
			end, { 1 }), i(0) }
		)
	),
	s(
		"ef",
		fmt(
			[[
useEffect(() => {{
	{2}
}}{1});
]],
			{ c(1, { t(""), t(", []") }), i(0) }
		)
	),
	s(
		"htmlEscape",
		fmt(
			[[
export function htmlEscape(text: string): string {{
	return text
		.replace(/&$/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/"/g, "&quot;")
		.replace(/'/g, "&#039;");
}}
]],
			{}
		)
	),
	s(
		"cap",
		fmt(
			[[
export const capitalize = (input: string): string =>
	input.charAt(0).toUpperCase() + input.slice(1);
]],
			{}
		)
	),
	s(
		"af",
		fmt(
			[[
async function {1}(): Promise<{2}> {{
	{3}
}}
]],
			{ i(1), i(2), i(0) }
		)
	),
}
