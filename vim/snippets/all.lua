local function cmd(command)
	local file = io.popen("zsh -c '" .. command .. "'", "r")
	if file == nil then
		return "nil!"
	end

	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

return {
	s(
		"gpl",
		fmt(
			[[
Copyright © {1} {2}. All rights reserved.

{3} is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License version 3
as published by the Free Software Foundation.

{3} is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with {3}. If not, see <https://www.gnu.org/licenses/>.
]],
			{
				i(1, "year"),
				i(2, "author"),
				i(3, "program"),
			},
			{ repeat_duplicates = true }
		)
	),
	s(
		"agpl",
		fmt(
			[[
Copyright © {1} {2}. All rights reserved.

{3} is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License version 3
as published by the Free Software Foundation.

{3} is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with {3}. If not, see <https://www.gnu.org/licenses/>.
]],
			{
				i(1, "year"),
				i(2, "author"),
				i(3, "program"),
			},
			{ repeat_duplicates = true }
		)
	),
	s(
		"months",
		c(1, {
			t({
				"January",
				"February",
				"March",
				"April",
				"May",
				"June",
				"July",
				"August",
				"September",
				"October",
				"November",
				"December",
			}),
			t({
				"Jan",
				"Feb",
				"Mar",
				"Apr",
				"May",
				"Jun",
				"Jul",
				"Aug",
				"Sep",
				"Oct",
				"Nov",
				"Dec",
			}),
		})
	),
	s(
		"days",
		c(1, {
			t({ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }),
			t({ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }),
		})
	),
	s(
		"thicc",
		fmt(
			[[
/********************************************************/
/*{1}{2}{3}*/
/********************************************************/
]],
			{
				f(function(args)
					return string.rep(" ", (54 - string.len(args[1][1])) / 2)
				end, { 1 }),
				i(1),
				f(function(args)
					return string.rep(" ", math.ceil((54 - string.len(args[1][1])) / 2))
				end, { 1 }),
			}
		)
	),
	s(
		"box",
		fmt(
			[[
##########################################################
#{1}{2}{3}#
##########################################################
]],
			{
				f(function(args)
					return string.rep(" ", (56 - string.len(args[1][1])) / 2)
				end, { 1 }),
				i(1),
				f(function(args)
					return string.rep(" ", math.ceil((56 - string.len(args[1][1])) / 2))
				end, { 1 }),
			}
		)
	),
	s(
		{ trig = "rand(%d*)", regTrig = true, hidden = true },
		f(function(_, parent)
			local length = parent.captures[1] or "32"
			if string.len(length) == 0 then
				length = "32"
			end
			return cmd('cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w ' .. length .. " | head -n 1")
		end)
	),
	s(
		"now",
		c(1, {
			f(function()
				return cmd("date --iso-8601=seconds")
			end),
			f(function()
				return cmd("date +%s%3N")
			end),
		})
	),
	s(
		"lic",
		f(function()
			return cmd('cat "$(git rev-parse --show-toplevel || echo .)"/.lic')
		end)
	),
	s({ trig = "sh(%b())", regTrig = true, hidden = true }, {
		f(function(_, parent)
			local cap = parent.captures[1]
			local command = string.sub(cap, 2, string.len(cap) - 1)
			return cmd(command)
		end),
	}),
	s({ trig = "bc(%b())", regTrig = true, hidden = true }, {
		f(function(_, parent)
			local cap = parent.captures[1]
			local command = string.sub(cap, 2, string.len(cap) - 1)
			return cmd('echo "' .. command .. '" | bc -l')
		end),
	}),
	s({ trig = "bce(%b())", regTrig = true, hidden = true }, {
		f(function(_, parent)
			local cap = parent.captures[1]
			local command = string.sub(cap, 2, string.len(cap) - 1)
			return command .. " = " .. cmd('echo "' .. command .. '" | bc -l')[1]
		end),
	}),
	s({ trig = "(%d+)%.%.(%.?)(%d+)", regTrig = true, hidden = true }, {
		f(function(_, parent)
			local startN = tonumber(parent.captures[1], 10)
			local inc = parent.captures[2] == "."
			local endN = tonumber(parent.captures[3], 10) - 1

			if inc then
				endN = endN + 1
			end

			local ret = ""
			for i = startN, endN do
				ret = ret .. i .. ", "
			end

			return string.sub(ret, 1, string.len(ret) - 2)
		end),
	}),
}
