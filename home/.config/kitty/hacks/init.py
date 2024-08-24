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
from typing import List

from kitty.boss import Boss
from kitty.constants import config_dir
from kitty.utils import timed_debug_print

from kittens.tui.handler import result_handler

from os import listdir
from os.path import dirname, join, basename, isdir, exists
import importlib.util

def main(args: List[str]) -> str:
    pass

@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    hacks_dir = join(config_dir, dirname(args[0]))

    # Scan through the `~/.config/kitty/hacks` directory looking for hacks
    # to apply. Hacks are Python modules.
    hacks = [file for file in listdir(hacks_dir) if
        (file.endswith(".py") and file != basename(args[0])) or
        (isdir(file) and exists(join(file, "__init__.py")))
    ]

    # Load the hacks.
    for hack in hacks:
        timed_debug_print(f"[ethp] Loading hack: {hack}")
        spec = importlib.util.spec_from_file_location(f"kitten_hacks.{hack.removesuffix(".py")}", join(hacks_dir, hack))
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)

    # Done.
    timed_debug_print(f"[ethp] Applied all hacks.")
