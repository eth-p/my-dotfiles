from typing import Any, Dict

from kitty.boss import Boss
from kitty.window import Window, DynamicColor

def on_focus_change(boss: Boss, window: Window, data: Dict[str, Any])-> None:
    if data["focused"]:
        window.change_colors({DynamicColor.default_bg: "#1C1C1C"})
    else:
        window.change_colors({DynamicColor.default_bg: "#121212"})
