-- Catppuccin theme

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- load this before everything else, so the UI doesn't flash

	config = function()
		-- set the theme
		require("catppuccin").setup({
			flavour = "latte", -- the light theme
			transparent_background = true,
			integrations = { -- Integrate with various LazyVim plugins
				cmp = true, -- Integrate with suggestion completions
				neotree = true, -- Integrate with file explorer
				treesitter = true,
				mason = true,
                gitsigns = true,
                nvimtree = tree
			},
		})
	end,
}
