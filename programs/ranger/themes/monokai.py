# my-dotfiles | Copyright (C) 2021-2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, normal, default, dim, underline

class _Color():
    def __init__(self, c, dim):
        self.c = c
        self.dim = dim

_palette_white  = _Color(253, 243)
_palette_grey   = _Color(247, 247)
_palette_red    = _Color(161, 88)
_palette_orange = _Color(208, 172)
_palette_yellow = _Color(221, 178)
_palette_green  = _Color(112, 70)
_palette_cyan   = _Color(81, 39)
_palette_purple = _Color(99, 55)

_chrome = 235

# pylint: disable=too-many-branches,too-many-statements
class Monokai(ColorScheme):
    progress_bar_color = 108

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        # File browser.
        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal

            if context.empty:
                fg = 241

            if context.error:
                fg = 1
                attr |= bold

            if context.border:
                fg = _chrome

            if context.image or context.audio or context.video:
                fg = _palette_orange.c

            if context.document:
                fg = _palette_yellow.c

            if context.container: # e.g. .zip
                fg = _palette_red.c
                attr |= dim

            if context.directory:
                fg = _palette_cyan.c

            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = _palette_red.c
                attr |= bold

            if context.socket:
                fg = _palette_red.c
                attr |= bold

            if context.fifo or context.device:
                fg = _palette_yellow.c
                if context.device:
                    attr |= bold

            if context.link:
                fg = _palette_red.c
                if not context.good:
                    bg = 52

            if context.tag_marker and not context.selected:
                attr |= bold
                fg = 244

            if not context.selected and (context.cut or context.copied):
                fg = 108
                bg = 234

            if context.copied:
                bg = 28
                fg = 154

            if context.cut:
                bg = 94
                fg = 184

            if context.main_column:
                if context.selected:
                    attr |= bold

                if context.marked:
                    attr |= bold
                    bg = 237

            if context.badinfo:
                if attr & reverse:
                    bg = 95
                else:
                    fg = 95

        # Title bar colors.
        elif context.in_titlebar:
            bg = 236

            # Current file.
            fg = _palette_yellow.c

            # Other.
            if context.hostname:
                fg = 160 if context.bad else 249
            elif context.directory:
                fg = 252
            elif context.tab:
                fg = 245
                bg = 239
                if context.good:
                    fg = _palette_yellow.c
                    bg = 236
                    attr |= bold
            elif context.link:
                fg = 116
            else:
                bg = 236
                attr |= bold
                

        # Status bar colors.
        elif context.in_statusbar:
            bg = _chrome
            fg = 250

            if context.permissions:
                if context.good:
                    fg = _palette_grey.c
                elif context.bad:
                    fg = _palette_red.c

            if context.marked:
                attr |= bold | reverse
                fg = _palette_yellow.c

            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 174

            if context.loaded:
                bg = self.progress_bar_color

            if context.vcsinfo:
                fg = 116
                attr &= ~bold

            if context.vcscommit:
                fg = 144
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 116

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = _palette_red.dim
            elif context.vcschanged:
                fg = _palette_orange.dim
            elif context.vcsunknown:
                fg = 174
            elif context.vcsstaged:
                fg = _palette_yellow.dim
            elif context.vcssync:
                fg = _palette_white.dim
            elif context.vcsignored:
                fg = 242

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = _palette_white.dim
            elif context.vcsbehind:
                fg = _palette_orange.dim
            elif context.vcsahead:
                fg = _palette_green.dim
            elif context.vcsdiverged:
                fg = _palette_red.dim
            elif context.vcsunknown:
                fg = 174

        return fg, bg, attr
