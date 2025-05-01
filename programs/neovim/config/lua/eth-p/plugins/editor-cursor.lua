-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
return {

	-- stay-centered
	--
	-- Repo: https://github.com/arnamak/stay-centered.nvim
	-- Docs: https://github.com/arnamak/stay-centered.nvim
	--
	-- Keep the cursor centered at all times.
	--
	{
		"arnamak/stay-centered.nvim",

		lazy = true,
		event = {
			"VeryLazy",
		},
		cmds = {
			"ToggleCenteredCursor",
		},

		opts = {
			enabled = opts.editor.cursor.keep_centered,
		},
	},
}
