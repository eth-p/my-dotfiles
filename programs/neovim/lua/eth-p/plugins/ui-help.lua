-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local opts = require("eth-p.opts")
return {

	-- which-key
	--
	-- Repo: https://github.com/folke/which-key.nvim
	-- Docs: https://github.com/folke/which-key.nvim
	--
	-- Display the keymaps.
	--
	{
		"folke/which-key.nvim",
		version = "^3.0.0",

		event = "VeryLazy",
		lazy = true,
		cond = opts.keymap.help,

		opts = {
			plugins = {
				presets = {
					windows = false,
					nav = false,
				},
			},
			icons = {
				mappings = opts.ui.nerdfonts,
			},
			replace = {
				key = {}, -- forces labels
			},
		},

		-- keys = {
		--   {
		-- 	"<leader>?",
		-- 	function()
		-- 	  require("which-key").show({ global = false })
		-- 	end,
		-- 	desc = "Buffer Local Keymaps (which-key)",
		--   },
		-- },

		config = function(self)
			local wk = require("which-key")
			wk.setup(self.opts)
			wk.add {

				-- Common built-in key bindings.
				{ "<C-W>c", desc = "Close window" },
				{ "<C-W>o", desc = "Close other windows" },
			}
		end,
	},
}
