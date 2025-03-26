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

		keys = {
			{
				"<C-W><Tab>",
				function()
					if vim.bo.filetype == "neo-tree" then
						vim.api.nvim_input("<C-W>p") -- go to previous window
					else
						vim.cmd("Neotree source=last")
					end
				end,
				desc = "Toggle focus on neo-tree",
			},
		},

		opts = {
			source_selector = {
				statusline = true,
			},
		},
	},
}
