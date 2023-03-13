---@diagnostic disable: undefined-global
return {
	s("cw", fmt("System.out.println({});", i(0))),
	s("cl", fmt("System.out.print({});", i(0))),
	s("pf", fmt('System.out.printf("{}");', i(0))),
	s("pl", fmt('System.out.printf("{}\\n");', i(0))),
	s(
		"jstart",
		fmt(
			[[
/**
 * @author Jayden Chan
 * @version 1.0
 * Date Created: {1}
 *
 * {2} 
 */

public class {3} {{

}}
]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		"main",
		fmt(
			[[
public static void main(String args[]) {{
	System.out.println("Hello World!");
}}
]],
			{}
		)
	),
	s(
		"for",
		fmt(
			[[
for(int {1} = {2}; {1} < {3}; {1}++) {{
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
for(int {1} = {2}-1; {1} >= 0; {1}--) {{
	{3}
}}
]],
			{ i(1), i(2), i(0) },
			{ repeat_duplicates = true }
		)
	),
}
