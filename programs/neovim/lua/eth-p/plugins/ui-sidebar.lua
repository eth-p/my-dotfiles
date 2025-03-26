-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local utils = require("eth-p.utils")
return {

	-- neo-tree.nvim
	--
	-- Repo: https://github.com/nvim-neo-tree/neo-tree.nvim
	-- Docs: https://github.com/nvim-neo-tree/neo-tree.nvim
	--
	-- Plugin to manage the file system and other tree like structures.
	--
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = utils.optional_deps {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			opts.ui.nerdfont and "nvim-tree/nvim-web-devicons",
		},

		lazy = false,

		opts = {
			source_selector = {
				winbar = true,
				statusline = false,
			},
		},
	},
}
