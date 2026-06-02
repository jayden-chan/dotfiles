---@diagnostic disable: undefined-global
return {
	s("cout", fmt('cout << "{1}"{2};', { i(1), i(0) })),
	s("coutl", fmt("std::cout << \"{1}\" << '\n';", { i(0) })),
}
