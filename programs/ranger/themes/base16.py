# my-dotfiles | Copyright (C) 2021-2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, normal, default, dim, underline

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
                fg = 8

            if context.error:
                fg = 1
                attr |= bold

            if context.border:
                fg = _chrome

            if context.image or context.video:
                fg = 5
                if context.video:
                    attr |= bold

            if context.audio:
                fg = 5
                
            if context.document:
                fg = 3

            if context.container: # e.g. .zip
                fg = 5
                attr |= dim

            if context.directory:
                fg = 6
                attr |= bold

            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = 2
                attr |= bold

            if context.socket:
                fg = 1
                attr |= bold

            if context.fifo or context.device:
                fg = 1
                if context.device:
                    attr |= bold

            if context.link:
                fg = 12
                attr |= dim
                if not context.good:
                    bg = 1

            if context.tag_marker and not context.selected:
                attr |= bold
                fg = 244

            if not context.selected and (context.cut or context.copied):
                fg = 108
                bg = 234

            if context.main_column:
                if context.selected:
                    attr |= bold

                if context.marked:
                    attr |= bold
                    bg = 8

            if context.copied:
                bg = 2
                fg = 0

            if context.cut:
                bg = 5
                fg = 0

            if context.badinfo:
                if attr & reverse:
                    bg = 95
                else:
                    fg = 95

        # Title bar colors.
        elif context.in_titlebar:
            bg = 236

            # Current file.
            fg = 5

            # Other.
            if context.hostname:
                fg = 1 if context.bad else 7
            elif context.directory:
                fg = 252
            elif context.tab:
                fg = 245
                bg = 239
                if context.good:
                    fg = 3
                    bg = 236
                    attr |= bold
            elif context.link:
                fg = 4
            else:
                bg = 236
                attr |= bold
                

        # Status bar colors.
        elif context.in_statusbar:
            bg = _chrome
            fg = 250

            if context.permissions:
                if context.good:
                    fg = 8
                elif context.bad:
                    fg = 1

            if context.marked:
                attr |= bold | reverse
                fg = 3

            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 1

            if context.loaded:
                bg = self.progress_bar_color

            if context.vcsinfo:
                fg = 4
                attr &= ~bold

            if context.vcscommit:
                fg = 4
                attr &= ~bold
                attr |= dim

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
                fg = 1
            elif context.vcschanged:
                fg = 4
            elif context.vcsunknown:
                fg = 8
            elif context.vcsstaged:
                fg = 2
            elif context.vcssync:
                fg = 7
                attr |= dim
            elif context.vcsignored:
                fg = 8
                attr |= dim

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            attr |= dim
            if context.vcssync:
                fg = 7
            elif context.vcsbehind:
                fg = 5
            elif context.vcsahead:
                fg = 2
            elif context.vcsdiverged:
                fg = 1
            elif context.vcsunknown:
                fg = 8
                attr &= ~dim

        return fg, bg, attr
