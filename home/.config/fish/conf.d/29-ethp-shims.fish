# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script shims out or aliases interactive commands that might not
#   be available on certain platforms.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This adds shell command aliases.
#
# =============================================================================

if status is-interactive

	if test (uname -s) = "Darwin" 

		# lsusb
		if not command -vq lsusb && not functions -q lsusb
			alias lsusb "system_profiler SPUSBDataType"
		end

	end

end

