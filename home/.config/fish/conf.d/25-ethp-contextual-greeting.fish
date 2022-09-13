# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will disable the fish greeting whenever the shell is not
#   the first instance of fish inside a dedicated terminal. (e.g. after
#   opening a new pane or through an IDE terminal.)
#
# How it's used in my-dotfiles
# ----------------------------
#
#   When `~/.local/libexec/tmux-new-window` creates a new shell instance,
#   the environment variable $INIT_TMUX_PANE_CREATOR (or $TMUX_PANE_CREATOR)
#   is set. The existence of this variable tells the script that the new shell
#   instance is not the first tmux pane, and therefore should not have a
#   greeting message. 
#
# =============================================================================

set -g ethp_greeting_contexts
set -g ethp_greeting_toplevel true

if not set -q ethp ethp_greeting_order
	set -g ethp_greeting_order 'ssh' 'ide' 'tmux' 'fish'
end

set -l in_ide false
set -l in_ssh false
set -l in_tmux false

# Detect if running within an IDE.
if [ -n "$VSCODE_IPC_HOOK_CLI" ];    set in_ide true; end

# Detect if running within SSH.
if [ -n "$SSH_CONNECTION" ];         set in_ssh true; end
if [ -n "$SSH_CLIENT" ];             set in_ssh true; end

# Detect if running from a new tmux pane.
if [ -n "$TMUX" ];                   set in_tmux true; end
if [ -n "$TMUX_PANE_CREATOR" ];      set ethp_greeting_toplevel false; end
if [ -n "$INIT_TMUX_PANE_CREATOR" ]; set ethp_greeting_toplevel true; end

# Set the context array.
if $in_ide;  set -a ethp_greeting_contexts "ide";  end
if $in_ssh;  set -a ethp_greeting_contexts "ssh";  end
if $in_tmux; set -a ethp_greeting_contexts "tmux"; end

# Create a function for calling the greetings.
function __ethp_call_greetings
	set -l greeting
	for greeting in $ethp_greeting_order
		if functions --query "ethp_greeting_$greeting" \
			&& contains "$greeting" "fish" $ethp_greeting_contexts
			"ethp_greeting_$greeting"
		end
	end
end

# Copy the original fish_greeting function, if it's not the fish default one.
set -l greeting_file (functions fish_greeting --details --verbose | head -n1)
if not string match --quiet "*/share/fish/functions/fish_greeting.fish" -- "$greeting_file"
	if not functions --query ethp_greeting_fish
		functions --copy fish_greeting ethp_greeting_fish
	end
end

# Set the fish_greeting function.
begin
	printf "function fish_greeting\n"
	printf "\t# %s\n" \
		"The `fish_greeting` function has been redefined to support" \
		"contextual greeting messages. See this file for more info:" \
		"" \
		"    ~/.config/fish/conf.d/25-ethp-contextual-greeting.fish"
	
	printf "\t__ethp_call_greetings\n\n"

	if $in_ide
		printf "\t# Detected fish within IDE. Declare `ethp_greeting_ide` for a greeting message.\n"
	end

	if $in_ssh
		printf "\t# Detected fish within SSH. Declare `ethp_greeting_ssh` for a greeting message.\n"
	end

	if $in_tmux
		printf "\t# Detected fish within TMUX. Declare `ethp_greeting_tmux` for a greeting message.\n"
	end

	printf "end\n"
end | source -
