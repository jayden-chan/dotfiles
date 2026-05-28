local plugins = require("config.plugins_list")
return {
	plugins.gitlinker,
	lazy = true,
	cmd = "GitLink",
	opts = {
		router = {
			browse = {
				["^git%.jayden%.codes"] = "https://git.jayden.codes/"
					.. "{_A.ORG}/"
					.. "{_A.REPO}/src/commit/"
					.. "{_A.REV}/"
					.. "{_A.FILE}?display=source" -- '?display=source'
					.. "#L{_A.LSTART}"
					.. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
			},
			blame = {
				["^git%.jayden%.codes"] = "https://git.jayden.codes/"
					.. "{_A.ORG}/"
					.. "{_A.REPO}/blame/commit/"
					.. "{_A.REV}/"
					.. "{_A.FILE}?display=source" -- '?display=source'
					.. "#L{_A.LSTART}"
					.. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
			},
			default_branch = {
				["^git%.jayden%.codes"] = "https://git.jayden.codes/"
					.. "{_A.ORG}/"
					.. "{_A.REPO}/src/branch/"
					.. "{_A.DEFAULT_BRANCH}/"
					.. "{_A.FILE}?display=source" -- '?display=source'
					.. "#L{_A.LSTART}"
					.. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
			},
			current_branch = {
				["^git%.jayden%.codes"] = "https://git.jayden.codes/"
					.. "{_A.ORG}/"
					.. "{_A.REPO}/src/branch/"
					.. "{_A.CURRENT_BRANCH}/"
					.. "{_A.FILE}?display=source" -- '?display=source'
					.. "#L{_A.LSTART}"
					.. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
			},
		},
	},
}
