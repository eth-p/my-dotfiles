-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
local utils = require("eth-p.utils")
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

	-- indent-blankline
	--
	-- Repo: https://github.com/lukas-reineke/indent-blankline.nvim
	-- Docs: https://github.com/lukas-reineke/indent-blankline.nvim
	--
	-- Shows identation guides.
	--
	{
		"lukas-reineke/indent-blankline.nvim",

		lazy = true,
		event = {
			"VeryLazy",
		},

		main = "ibl",
		opts = {
			enabled = opts.editor.indents.guides_always,
			scope = {
				enabled = false,
			},
		},

		config = function(self)
			local augroup = utils.augroup("editor-indents.indent-blankline")
			local ibl = require("ibl")

			-- Setup.
			ibl.setup(self.opts)

			-- Enable for configured filetypes.
			utils.on_filetypes(opts.editor.indents.guides_on_filetypes, {
				group = augroup,
				callback = function(evt)
					ibl.setup_buffer(evt.buf, { enabled = true })
				end,
			})
		end,
	},
}
