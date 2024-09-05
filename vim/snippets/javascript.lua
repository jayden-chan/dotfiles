---@diagnostic disable: undefined-global

local log_snippet = function(trigger, level)
	return s(
		trigger,
		fmt("logger." .. level .. "({})", {
			c(1, {
				sn(nil, { t('"'), i(1), t('"') }),
				sn(nil, { t('{ message: "'), i(1), t('"'), i(2), t(" }") }),
				sn(nil, { t("`"), i(1), t("`") }),
				sn(nil, { t("{ message: `"), i(1), t("`"), i(2), t(" }") }),
			}),
		})
	)
end

return {
	s("log", fmt("console.log({})", i(0))),
	s("linesplit", t(".split(/\\r?\\n/g).map(l => l.trim()).filter(l => l.length > 0)")),
	s("er", fmt("console.error({})", i(0))),
	log_snippet("deb", "debug"),
	log_snippet("info", "info"),
	log_snippet("warn", "warn"),
	log_snippet("err", "error"),
	log_snippet("crit", "crit"),
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
		"hvc",
		fmt(
			[[
const use{1} = () => {{
	return {{ hello: "world" }};
}};

type {1}Props = ReturnType<typeof use{1}>;
const {1}View = (props: {1}Props) => {{
	return <div>{2}</div>;
}};

export const {1} = () => <{1}View {{...use{1}()}} />;
]],
			{ i(1), i(0) },
			{ repeat_duplicates = true }
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
{1}async function {2}(): Promise<{3}> {{
	{4}
}}
]],
			{ c(1, { t(""), t("export ") }), i(2), i(3), i(0) }
		)
	),
}
