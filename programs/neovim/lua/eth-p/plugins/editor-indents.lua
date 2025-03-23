-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
return {

	-- guess-indent
	--
	-- Repo: https://github.com/NMAC427/guess-indent.nvim
	-- Docs: https://github.com/NMAC427/guess-indent.nvim?tab=readme-ov-file#configuration
	--
	-- TODO USAGE
	--
	{
		"nmac427/guess-indent.nvim",

		lazy = true,
		event = {
			"BufNewFile",
			"BufRead",
			"StdinReadPost",
		},

		cmd = {
			"GuessIndent",
		},

		opts = {
			auto_cmd = opts.editor.indents.detect,
			filetype_exclude = {
				"netrw", -- default
				"tutor", -- default
				"make", -- can be a mix of both  spaces and tabs
			},
		},
	},
}
