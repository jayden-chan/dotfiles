---@diagnostic disable: undefined-global
return {
	s(
		"cstart",
		fmt(
			[[
/*
    Author: Jayden Chan
    Date: {1}
*/
#include <stdio.h>
#include <stdlib.h>

int main() {{
    {2}
    return EXIT_SUCCESS;
}}
]],
			{ i(1), i(0) }
		)
	),

	s("in", fmt("#include {}", i(0))),
	s("pf", fmt('printf("{}");', i(0))),
	s("pl", fmt('printf("{}\\n");', i(0))),

	s(
		"for",
		fmt(
			[[
for (int {1} = {2}; {1} < {3}; ++{1}) {{
    {4}
}}
]],
			{ i(1), i(2), i(3), i(0) },
			{ repeat_duplicates = true }
		)
	),
}
