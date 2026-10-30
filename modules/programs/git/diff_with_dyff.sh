set -euo pipefail

# Print a header similar to delta.
printf "\n\033[34m%s\033[m\n" "$1"
printf "\033[34m"
printf "%-$(tput cols)s" "" | sed 's/ /─/g'
printf "\033[m\n"

# Function to fallback to regular diff in the file cannot be parsed.
fallback_diff() {
	{ diff -u "$2" "$5" || true; } | sed '/^\(+++\|---\)/d'
}

# Perform the diff.
dyff --color on between --omit-header "$2" "$5" 2>/dev/null ||
	fallback_diff "$@"
