return {
	{
		"gbprod/nord.nvim",
		name = "nord",
		priority = 1000,
		opts = {
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
			colorscheme = "nord",
		},
	},
}
