return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			on_highlights = function(highlights, colors)
				highlights.NormalFloat = { bg = "none" }
				highlights.FloatBorder = { bg = "none" }
				highlights.FloatTitle = { bg = "none" }
			end,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
}
