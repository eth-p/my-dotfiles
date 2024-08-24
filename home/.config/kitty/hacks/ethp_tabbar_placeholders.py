# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Adds extra placeholder options to the tab bar.
#
# Placeholders
# ------------
#
#   {tab.flags()}       Flags similar to tmux.
#
# =============================================================================
from typing import List

from kitty.tab_bar import TabAccessor
from kitty.fast_data_types import get_boss

# -----------------------------------------------------------------------------
# Tabs:
# -----------------------------------------------------------------------------

def tab_flags(self, zoom=['Z', ' '], active=['*', '-', ' ']) -> str:
    boss = get_boss()
    tab = boss.tab_for_id(self.tab_id)
    tm = tab.tab_manager_ref()

    # Determine if the tab is active or the previously-active tab.
    #   0   -- Active
    #   1   -- Previously active
    #   2   -- Inactive
    active_index = 2
    if tm is not None and len(tm.active_tab_history) > 0:
        if self.tab_id == tm.active_tab_history[-1]:
            active_index = 1
        elif tab is tm.active_tab:
            active_index = 0

    # Add the flags to a list.
    flags = [
        active[active_index],
        zoom[0 if tab.current_layout.name == "stack" else 1],
    ]

    # Shift whitespace to the end.
    flags_ws = [f for f in flags if f.strip() == ""]
    flags_cz = [f for f in flags if f.strip() != ""]

    return "".join(flags_cz) + "".join(flags_ws)

TabAccessor.flags = tab_flags
# active_tab_history[tab_num]