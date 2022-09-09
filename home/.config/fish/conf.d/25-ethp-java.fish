# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script creates alias functions for each different version of
#   the JVM installed on the system.
#
#
# Requirements
# ------------
#
#   * 3-ethp-query-distro.fish                     (for determining the OS)
#
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This creates aliases such as `java11`, and wraps the `java` command to
#   use the `$JAVA_HOME` variable on all platforms.
#
# =============================================================================

set -l javas
set -l java
set -l java_version

# -----------------------------------------------------------------------------
# Search for installed JVMs/JREs.
# Supports:
#   - MacOS (Homebrew)
#   - Arch
# -----------------------------------------------------------------------------
switch "$ethp_sys_distro"

case "darwin"
	if command -vq brew
		for java in (brew --prefix)/opt/openjdk@*
			set java_version (string match --regex --groups-only '@(\d+)$' -- (basename "$java"))
			set javas $javas (printf '%s\t%s' "$java_version" "$java")
		end
	end

case "arch"
	for java in /usr/lib/jvm/*
		if not test -L "$java"
			set java_version (string match --regex --groups-only "^java-(\d+)-" -- (basename "$java"))
			set javas $javas (printf '%s\t%s' "$java_version" "$java")
		end
	end

case "termux"
	# TODO

end

# -----------------------------------------------------------------------------
# Create functions for running specific Java versions.
#
# Iterates through all the detected JVMs and creates a corresponding `java#`
# function for each.
#
# Can also be used to set the JAVA_HOME variable with the `--use` flag.
# -----------------------------------------------------------------------------
for java in $javas
	set -l parts (string split (printf "\t") -- "$java")
	set -l java_version $parts[1]
	set -l java_home $parts[2]

	function "java$java_version" \
		--description="Java $java_version" \
		--wraps="java" \
		--inherit-variable="java_home" \
		--inherit-variable="java_version"

		argparse --ignore-unknown --stop-nonopt 'use' 'home' -- $argv || return $status

		if test -n "$_flag_use"
			set -gx JAVA_HOME "$java_home"
			printf "\x1B[32mSwitched \x1B[0mJAVA_HOME\x1B[32m to Java %s.\x1B[0m\n" "$java_version"
			return 0
		end

		if test -n "$_flag_home"
			echo "$java_home"
			return 0
		end

		set -x JAVA_HOME "$java_home"
		"$java_home/bin/java" $argv
		return $status
	end

	complete --command "java$java_version" --long-option 'use' --no-files --description "set JAVA_HOME to Java $java_version"
	complete --command "java$java_version" --long-option 'home' --no-files --description "print JAVA_HOME for Java $java_version"
end

# -----------------------------------------------------------------------------
# Create aliases for Java commands to use the JAVA_HOME versions.
# -----------------------------------------------------------------------------
function __create_java_alias
	set -l cmd $argv[1]
	function "$cmd" \
		--wraps="java" \
		--inherit-variable=cmd
		
		if test -z "$JAVA_HOME"
			command "$cmd" $argv
			return $status
		end

		"$JAVA_HOME/bin/$cmd" $argv
		return $status
	end
end

__create_java_alias java
__create_java_alias javac
__create_java_alias javadoc

functions -e __create_java_alias

