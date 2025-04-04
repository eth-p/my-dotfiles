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

-- on_filetypes creates an autocommand that executes the callback for
-- buffers of the specified filetype. The opts parameter uses the same
-- format as `nvim_create_autocmd`, with the exception of `pattern` being
-- overridden to `*`.
function on_filetypes(filetypes, opts)
	local callback = opts.callback

	-- Convert the filetypes list to a map.
	local filetypes_map = {}
	for key, val in pairs(filetypes) do
		if type(val) == "boolean" and val == true then
			-- { ft = enabled }
			filetypes_map[key] = val
		else
			-- { ft, ft2, ... }
			filetypes_map[val] = true
		end
	end

	-- Create the autocmd.
	local aucmd_id = vim.api.nvim_create_autocmd(
		"FileType",
		vim.tbl_deep_extend("force", opts, {
			pattern = "*",
			callback = function(evt)
				if filetypes_map[evt.match] == true then
					callback(evt)
				end
			end,
		})
	)

	-- Iterate all the buffers once (in case of plugin reload).
	for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf_id) then
			local buf_ft = vim.bo[buf_id].filetype
			if filetypes_map[buf_ft] == true then
				callback {
					id = aucmd_id,
					event = "FileType",
					group = opts.group,
					file = vim.api.nvim_buf_get_name(buf_id),
					match = buf_ft,
					buf = buf_id,
				}
			end
		end
	end

	return aucmd_id
end

-- set_hl is an extension of neovim's `nvim_set_hl` function that
-- supports creating linked highlights composed from multiple
-- different highlights.
--
-- Caveats:
--  * Linked highlights will be seen as regular highlights, and do not
--    automatically update when the linked highlight changes.
local function set_hl(ns, hl, opts)
	local links = opts.link
	if links == nil or type(links) ~= "table" then
		vim.api.nvim_set_hl(ns, hl, opts)
		return
	end

	-- Find the highlight groups referenced in the link.
	local linked_hls = {}
	for _, v in pairs(links) do
		if linked_hls[v] == nil then
			linked_hls[v] = vim.api.nvim_get_hl(0, { name = v })
		end
	end

	-- Dynamically generate the "linked" highlight group.
	local gen_hl = vim.tbl_deep_extend("force", {}, opts)
	gen_hl.link = nil
	for k, v in pairs(links) do
		gen_hl[k] = linked_hls[v][k]
	end

	-- Apply the generated group.
	vim.api.nvim_set_hl(ns, hl, gen_hl)
end

-- ternary is a function acting as a replacement for the ternary operator.
function ternary(cond, when_true, when_false)
	if cond then
		return when_true
	else
		return when_false
	end
end

return {
	optional_deps = optional_deps,
	augroup = augroup,
	on_filetypes = on_filetypes,
	ternary = ternary,
	set_hl = set_hl,
}
