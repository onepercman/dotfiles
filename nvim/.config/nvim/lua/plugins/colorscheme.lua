return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			on_highlights = function(highlights, colors)
				highlights.NormalFloat = { bg = "none" }
				highlights.FloatBorder = { bg = "none" }
				highlights.FloatTitle = { bg = "none" }
				highlights.WinSeparator = { fg = colors.fg_gutter, bold = true }
				highlights.LineNr = { fg = colors.dark5 }
				highlights.LineNrAbove = { fg = colors.dark5 }
				highlights.LineNrBelow = { fg = colors.dark5 }
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
