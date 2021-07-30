# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

complete -c session_var -f
complete -c session_var -l file -d "use a specific session file"
complete -c session_var -F -r -l file -d "print the session variable file"
complete -c session_var -F -r -l import-from-file -d "import session variables from file"

# --set
complete -c session_var -x -s s -l set -d "set a session variable"

# --erase
complete -c session_var -s e -l erase -d "erase a session variable"
complete -c session_var -x -n '
	__fish_seen_argument -s e -l erase && 
	[ (count (string match -v -- "-*" (commandline -o))) -eq 1 ]
	' -a '(session_var --list)'

# --list
complete -c session_var -x -l list -d "list all session variables"
complete -c session_var -x -n '__fish_seen_argument -l list' -l without -d "excluding a variable from the list"

# --clear
complete -c session_var -x -s c -l clear -d "clear all session variables"

