# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   **Credits:** https://github.com/ranger/ranger/wiki/Custom-Commands
#
#   Adds `fd_search`, `fd_prev`, and `fd_next` to ranger.
#
#
# How it's used in my-dotfiles
# ----------------------------
#
#   My `rc.conf` file binds `/`, `n`, and `S-n` to use fd instead of the
#   built-in search function.
#
# =============================================================================
import ranger.api
import os

def on_file_move(args):
    target = args["new"]
    fm = args["origin"]
    fm.run(
        ["tmux", "set-option", "-p", "@ranger-current-file", str(target)],
        flags='s',
        wait=False,
    )


def hook_ready(fm):
    fm.signal_bind("move", on_file_move)
    return HOOK_READY_OLD(fm)


if "TMUX" in os.environ:
    HOOK_READY_OLD = ranger.api.hook_ready
    ranger.api.hook_ready = hook_ready
