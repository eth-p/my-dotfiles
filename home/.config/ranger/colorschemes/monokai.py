# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, normal, default, dim, underline

_palette_white  = 253
_palette_grey   = 247
_palette_red    = 161
_palette_orange = 208
_palette_yellow = 221
_palette_green  = 112
_palette_cyan   = 81
_palette_purple = 99

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
                fg = _palette_orange

            if context.document:
                fg = _palette_yellow

            if context.container: # e.g. .zip
                fg = _palette_red
                attr |= dim

            if context.directory:
                fg = _palette_cyan

            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = _palette_red
                attr |= bold

            if context.socket:
                fg = _palette_red
                attr |= bold

            if context.fifo or context.device:
                fg = _palette_yellow
                if context.device:
                    attr |= bold

            if context.link:
                fg = _palette_red
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
            bg = _chrome

            # Current file.
            fg = _palette_cyan

            # Other.
            if context.hostname:
                fg = 160 if context.bad else 242
            elif context.directory:
                fg = 247
            elif context.tab:
                if context.good:
                    bg = 180
            elif context.link:
                fg = 116

        # Status bar colors.
        elif context.in_statusbar:
            bg = _chrome
            fg = 250

            if context.permissions:
                if context.good:
                    fg = _palette_grey
                elif context.bad:
                    fg = _palette_red

            if context.marked:
                attr |= bold | reverse
                fg = _palette_yellow

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
                fg = 95
            elif context.vcschanged:
                fg = 174
            elif context.vcsunknown:
                fg = 174
            elif context.vcsstaged:
                fg = 108
            elif context.vcssync:
                fg = 108
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = 108
            elif context.vcsbehind:
                fg = 174
            elif context.vcsahead:
                fg = 116
            elif context.vcsdiverged:
                fg = 95
            elif context.vcsunknown:
                fg = 174

        return fg, bg, attr
