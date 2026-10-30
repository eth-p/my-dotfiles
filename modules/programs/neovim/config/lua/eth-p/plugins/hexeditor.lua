-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local utils = require("eth-p.utils")
return {

	-- hex.nvim
	--
	-- Repo: https://github.com/RaafatTurki/hex.nvim
	-- Docs: hhttps://github.com/RaafatTurki/hex.nvim
	--
	-- Requires `xxd` on path.
	--
	-- TODO USAGE
	--
	{
		"RaafatTurki/hex.nvim",
		commit = "b46e63356a69e8d6f046c38a9708d55d17f15038",
		cond = opts.integration.xxd,

		lazy = true,
		event = {
			"BufNewFile",
			"BufRead",
			"StdinReadPost",
		},

		opts = {
			dump_cmd = opts.external_executables.xxd .. " -g 1 -u",
			assemble_cmd = opts.external_executables.xxd .. " -r",
		},
	},
}
