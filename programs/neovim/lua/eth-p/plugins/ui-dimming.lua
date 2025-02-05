-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
return {

	-- vimade
	--
	-- Repo: https://github.com/TaDaa/vimade
	-- Docs: https://github.com/TaDaa/vimade
	--
	-- Fades inactive windows.
	{
		"tadaa/vimade",

		lazy = true,
		event = "VeryLazy",
		cond = opts.ui.focus_dimming,

		opts = {
			recipe = { "default", { animate = false } },
			ncmode = "windows",

			fadelevel = 0.75,
			basebg = { 0, 0, 0 },

			enablefocusfading = true, -- Fade when neovim loses focus

			groupdiff = true,
			groupscrollbind = true,
		},
	},
}
