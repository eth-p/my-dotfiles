-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local cmds = {}

--=== :ToggleSidebar ===--
-- Toggles the sidebar visibility.
cmds.ToggleSidebar = function()
	if vim.b.ethp_sidebar_hidden_prev == nil then
		cmds.HideSidebar()
	else
		cmds.ShowSidebar()
	end
end

cmds.HideSidebar = function()
	if vim.b.ethp_sidebar_hidden_prev ~= nil then
		return
	end

	vim.b.ethp_sidebar_hidden_prev = {
		number = vim.opt_local.number:get(),
		relativenumber = vim.opt_local.relativenumber:get(),
		foldcolumn = vim.opt_local.foldcolumn:get(),
		signcolumn = vim.opt_local.signcolumn:get(),
	}

	vim.opt_local.number = false
	vim.opt_local.relativenumber = false
	vim.opt_local.foldcolumn = "0"
	vim.opt_local.signcolumn = "no"
end

cmds.ShowSidebar = function()
	if vim.b.ethp_sidebar_hidden_prev == nil then
		return
	end

	local prev = vim.b.ethp_sidebar_hidden_prev
	vim.opt_local.number = prev.number
	vim.opt_local.relativenumber = prev.relativenumber
	vim.opt_local.foldcolumn = prev.foldcolumn
	vim.opt_local.signcolumn = prev.signcolumn
	vim.b.ethp_sidebar_hidden_prev = nil
end

--=== :ToggleVisualWhitespace ===--
cmds.ToggleVisualWhitespace = function()
	require("visual-whitespace").toggle()
end

--=== :ToggleCenteredCursor ===--
cmds.ToggleCenteredCursor = function()
	require("stay-centered").toggle()
end

--=== :GitBlame ===--
cmds.GitBlame = function()
	local gitsigns = require("gitsigns")

	-- Check if there's a blame window open already.
	-- If there is, close it.
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "gitsigns-blame" then
			vim.api.nvim_win_close(win, {})
			return
		end
	end

	-- Show the blame, adding a mapping to close it with `q`.
	local cur_win = vim.api.nvim_get_current_win()
	gitsigns.blame(function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>:q<CR>", {
			noremap = true,
			nowait = true,
		})
		vim.api.nvim_set_current_win(cur_win)
	end)
end

return cmds
