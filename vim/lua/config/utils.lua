local M = {
	mirror = function(name)
		return "https://git.jayden.codes/mirrors/" .. name
	end,
	theme = {
		color_base = "base46",
		theme = "everforest",
	},
}

function LoadBase46ColorScheme(theme)
	local present, base46 = pcall(require, "base46")
	if not present then
		return
	end
	local theme_opts = {
		base = M.theme.color_base,
		theme = theme or M.theme.theme,
		transparency = false,
	}
	base46.load_theme(theme_opts)
end

return M
