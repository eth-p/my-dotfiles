-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
return {

	-- ufo
	--
	-- Repo: https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#installation
	-- Docs: https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#documentation
	--
	-- TODO USAGE
	--
	{
		"kevinhwang91/nvim-ufo",
		-- tag = "v1.4.0",
		commit = "c15fed422506a130a62e5e79c2d754392231d7d8",
		dependencies = { "kevinhwang91/promise-async" },
		cond = opts.editor.fold.enabled,

		lazy = true,
		event = {
			"BufNewFile",
			"BufRead",
			"StdinReadPost",
		},

		opts = {
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		},
	},
}
