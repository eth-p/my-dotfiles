-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
return {

	-- telescope
	--
	-- Repo: https://github.com/nvim-telescope/telescope.nvim
	-- Docs: https://github.com/nvim-telescope/telescope.nvim
	--
	-- TODO USAGE
	--
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },

		lazy = "true",

		cmd = {
			"Telescope",
		},

		keys = {
			{
				"<C-W><C-B>",
				"<Cmd>Telescope buffers<CR>",
				desc = "Switch active window buffer",
			},
		},
	},
}
