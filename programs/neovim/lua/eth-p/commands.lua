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

return cmds
