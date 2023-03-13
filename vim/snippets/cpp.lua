---@diagnostic disable: undefined-global
return {
	s("cout", fmt('cout << "{1}"{2};', { i(1), i(0) })),
	s("coutl", fmt("std::cout << \"{1}\" << '\n';", { i(0) })),
	s(
		"cppstart",
		fmt(
			[[
#include <iostream>

int main() {{
	std::cout << "Hello World!" << std::endl;
	return 0;
}}
]],
			{}
		)
	),
	s(
		"header",
		fmt(
			[[
#ifndef {1}_H
#define {1}_H

class {2}
{{
	public:
		{2}();
	protected:
	private:
}};

#endif // $1_H
]],
			{ i(1), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"ns",
		fmt(
			[[
namespace {1} {{
{2}
}} // namespace {1}
]],
			{ i(1), i(0) }
		)
	),
	s(
		"source",
		fmt(
			[[
#include <iostream>
#include "{1}.h"

{1}::{1}({2})
{{
	{3}
}}
]],
			{ i(1), i(2), i(0) }
		)
	),
}
