-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================
local augroup_auto_list = vim.api.nvim_create_augroup("", {})

-- build_listchar converts a key-value pair from a map into a value used in
-- vim's `listchars` option.
function build_listchar(name, val)
	-- Special case: tab
	-- Ensure length is at least 2 chars.
	if name == "tab" then
		local val_len = vim.fn.strdisplaywidth(val)
		if val_len == 1 then
			val = val .. " "
		end
	end

	return ("%s:%s"):format(name, val)
end

-- reconfigure updates the `listchars` option.
function set_listchars(vim_opts, listchars_map)
	-- Use the per-buffer options provided or default to global options.
	if vim_opts == nil then
		vim_opts = vim.opt
	end

	-- Build a list containing each of the listchars options.
	local listchars_to_set = {}
	for name, val in pairs(listchars_map) do
		if val ~= nil then
			table.insert(listchars_to_set, build_listchar(name, val))
		end
	end

	-- Set the listchars option.
	vim_opts.listchars = table.concat(listchars_to_set, ",")
end

function setup_auto_list(filetypes)
	vim.api.nvim_clear_autocmds { group = augroup_auto_list }
	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetypes,
		callback = function()
			vim.opt_local.list = true
		end,
	})
end

return {
	set_listchars = set_listchars,
	setup_auto_list = setup_auto_list,
}
