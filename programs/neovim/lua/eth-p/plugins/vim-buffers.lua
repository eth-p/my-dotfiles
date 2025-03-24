-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local utils = require("eth-p.utils")
return {

	-- clone-buffer
	--
	-- Repo: https://github.com/eth-p/nvim-clone-buffer
	-- Docs: https://github.com/eth-p/nvim-clone-buffer
	--
	-- A small neovim plugin for creating a scratch copy of the current buffer.
	--
	{
		"eth-p/nvim-clone-buffer",
		lazy = true,

		cmd = {
			"CloneBuffer",
			"CloneBufferInBackground",
		},

		keys = {
			{
				"<C-W><C-D>",
				"<Cmd>CloneBuffer<CR>",
				desc = "Clone to scratch buffer",
			},
		},

		opts = {},
	},
}
