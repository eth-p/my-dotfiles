-- my-dotfiles | Copyright (C) 2025 eth-p
-- Repository: https://github.com/eth-p/my-dotfiles
-- =============================================================================

-- optional_deps fixes a lazy.nvim dependency spec to remove optional dependencies.
function optional_deps(a, b)
	local result = {}
	for key, value in pairs(a) do
		if value ~= false then
			result[key] = value
		end
	end

	return result
end

-- augroup creates (or clears) an autogroup.
-- This should be used for registering autocmds in plugin initialization.
function augroup(name)
	return vim.api.nvim_create_augroup("eth-p." .. name, {
		clear = true,
	})
end

return {
	optional_deps = optional_deps,
	augroup = augroup,
}
