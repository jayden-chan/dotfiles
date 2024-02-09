---@diagnostic disable: undefined-global
return {
	s("pl", fmt('println!("{}"{})', { i(1), i(0) })),
	s("pf", fmt('print!("{}"{})', { i(1), i(0) })),
	s("ep", fmt('eprintln!("{}"{})', { i(1), i(0) })),
	s("ase", fmt("assert_eq!({})", { i(0) })),
	s("as", fmt("assert!({})", { i(0) })),
	s("asn", fmt("assert_ne!({})", { i(0) })),
	s("der", fmt("#[derive({})]", { i(0) })),
	s("des", t("#[derive(Serialize, Deserialize)]")),
	s("re", fmt("Result<{}, {}>", { i(1), i(0) })),
	s("op", fmt("Option<{}>", { i(0) })),
	s("any", fmt("anyhow!({})", { i(0) })),
	s("bail", fmt("anyhow::bail!({})", { i(0) })),
	s(
		"test",
		fmt(
			[[
#[test]
fn test_{1}() {{
	{2}
}}
]],
			{ i(1), i(0) }
		)
	),
	s(
		"testmod",
		fmt(
			[[
#[cfg(test)]
mod tests {{
	use super::*;
{1}
}}
]],
			{ i(0) }
		)
	),
	s(
		"bench",
		fmt(
			[[
#[bench]
fn bench_{1}() {{
	{2}
}}
]],
			{ i(1), i(0) }
		)
	),
}
