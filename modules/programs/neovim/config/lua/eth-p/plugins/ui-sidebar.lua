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
			opts.ui.nerdfonts and "nvim-tree/nvim-web-devicons",
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
			close_if_last_window = true,
			source_selector = {
				statusline = true,
			},
			default_component_configs = {
				indent = {
					expander_collapsed = "",
					expander_expanded = "",
				},
				icon = {
					folder_closed = utils.ternary(
						opts.ui.nerdfonts,
						"",
						">"
					),
					folder_open = utils.ternary(
						opts.ui.nerdfonts,
						"",
						"↘"
					),
					folder_empty = utils.ternary(
						opts.ui.nerdfonts,
						"󰜌",
						" "
					),
				},
				git_status = {
					symbols = {
						added = utils.ternary(opts.ui.nerdfonts, "✚", "A"),
						modified = utils.ternary(opts.ui.nerdfonts, "", "M"),
						deleted = utils.ternary(opts.ui.nerdfonts, "✖", "D"),
						renamed = utils.ternary(opts.ui.nerdfonts, "󰁕", "R"),
						untracked = utils.ternary(
							opts.ui.nerdfonts,
							"",
							"?"
						),
						ignored = utils.ternary(opts.ui.nerdfonts, "", "I"),
						unstaged = utils.ternary(
							opts.ui.nerdfonts,
							"󰄱",
							"-"
						),
						staged = utils.ternary(opts.ui.nerdfonts, "", "+"),
						conflict = utils.ternary(opts.ui.nerdfonts, "", "!"),
					},
				},
			},
			filesystem = {
				window = {
					mappings = utils.ternary(not opts.keymap.preserve, {
						["H"] = "none", -- old: toggle_hidden
						["z"] = { -- old: close_all_nodes
							"show_help",
							nowait = false,
							config = { prefix_key = "z" },
						},
						["zM"] = "close_all_nodes", -- consistent with neovim
						["zh"] = "toggle_hidden", -- consistent with ranger
					}, {}),
				},
			},
		},
	},
}
