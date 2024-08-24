# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Loads the hacks from this directory into kitty's Python runtime.
#
# =============================================================================
from enum import Enum
from typing import List, Optional

from kitty.cli import parse_args
from kitty.boss import Boss
from kitty.constants import config_dir
from kitty.utils import timed_debug_print
from kitty.layout.splits import Pair, Splits

from kittens.tui.handler import result_handler

from sys import stderr
from os import listdir
from os.path import dirname, join, basename, isdir, exists

DESCRIPTION = "Resize the current splits window edge"
OPTIONS = r'''
--by
default=1
type=int
The number of cells to resize.


--window
default=-1
type=int
The target window.
'''.format

def main(args: List[str]) -> str:
    try:
        _parse_args(args)
    except SystemExit as err:
        print(err.args[0], file=stderr)
        input('Press Enter to exit')
        return err.args[0]

@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    # Parse the args.
    try:
        parsed_args = _parse_args(args)
    except SystemExit as err:
        print(err.args[0], file=stderr)
        return

    target_window_id_from_args, edge, scale = parsed_args
    if target_window_id_from_args is not None:
        target_window_id = target_window_id_from_args

    # Get the target tab and layout.
    window = boss.window_id_map.get(target_window_id)
    tab = boss.tab_for_window(window)
    timed_debug_print(f"Target: {target_window_id}")
    timed_debug_print(tab)
    layout = tab.current_layout
    if layout.name != "splits":
        # Layout not supported.
        return

    # Get the pair for the current window.
    grp = tab.windows.group_for_window(target_window_id)
    if grp is None:
        timed_debug_print(f"[splits_resize] unable to get window group of window {target_window_id}")
        return

    pair = layout.pairs_root.pair_for_window(grp.id)
    if pair is None:
        timed_debug_print(f"[splits_resize] unable to get pair of window group {grp.id}")
        return

    # Adjust the pair.
    _adjust_window_bounds(boss, target_window_id, pair, edge, layout, by=scale)
    layout.do_layout(tab.windows)


def _parse_args(args: List[str]) -> tuple[Optional[int], '_Edge', Optional[int]]:
    cli_opts, items = parse_args(args[1:], OPTIONS, '', DESCRIPTION, args[0])
    if len(items) < 1:
        raise SystemExit("Must specify an edge to resize.")

    if len(items) > 1:
        raise SystemExit("Too many arguments.")

    edge = _Edge.from_string(items[0])
    if edge is None:
        raise SystemExit(f"Unknown edge '{items[0]}'")

    return (
        None if cli_opts.window == -1 else cli_opts.window,
        edge,
        cli_opts.by
    )


class _Edge(Enum):
    Top = "top"
    Left = "left"
    Bottom = "bottom"
    Right = "right"

    def from_string(value: str) -> Optional['_Edge']:
        if value in ["top", "up"]:       return _Edge.Top
        if value in ["left"]:            return _Edge.Left
        if value in ["bottom", "down"]:  return _Edge.Bottom
        if value in ["right"]:           return _Edge.Right


def _adjust_window_bounds(boss: Boss, window_id: int, pair: Pair, edge: _Edge, layout: Splits, by: int = 1) -> None:
    bias = 0.05
    root_pair = layout.pairs_root

    # Find the Pair responsible for the layout of this window on the target axis.
    target = window_id
    target_pair = pair
    desired_axis_horizontal = edge == _Edge.Left or edge == _Edge.Right

    while target_pair.horizontal != desired_axis_horizontal:
        target = target_pair
        target_pair = target_pair.parent(root_pair)
        if target_pair is None:
            return

    # Determine if the window is on the left/top side of the pair.
    is_one = target_pair.one == target
    timed_debug_print(f"Initial pair: {pair}")
    timed_debug_print(f"Target pair:  {target_pair}")
    timed_debug_print(f"Target id:    {target}")
    timed_debug_print(f"Is one? {is_one}; Edge {edge}")

    # Determine the bias and direction for the requested edge.
    if   edge is _Edge.Left  and     is_one: pass
    elif edge is _Edge.Left  and not is_one: bias *= -1
    elif edge is _Edge.Right and     is_one: bias *= -1
    elif edge is _Edge.Right and not is_one: pass
    elif edge is _Edge.Top  and not is_one: bias *= -1
    timed_debug_print(f"Bias: {bias}")
    target_pair.modify_size_of_child(window_id, bias, desired_axis_horizontal, layout)
    # boss.l
    #     grp = all_windows.group_for_window(window_id)
    #     if grp is None:
    #         return False
    #     pair = self.pairs_root.pair_for_window(grp.id)
    #     if pair is None:
    #         return False
    #     which = 1 if pair.one == grp.id else 2
    #     return pair.modify_size_of_child(which, increment, is_horizontal, self)
    # pass
    pass
