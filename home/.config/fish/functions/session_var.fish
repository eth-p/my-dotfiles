
function session_var
	argparse -x 'set,erase,clear,file,list-with-values,list,import-from-file,import-from-tty' \
		-x 'set,erase,clear,file,import-from-tty,without' \
		's/set' 'x/export' 'e/erase' 'c/clear' \
		'list' 'list-with-values' 'without=+' \
		'file' 'using-file=' 'import-from-tty=' 'import-from-file=' \
		-- $argv || return $status

	# Get the session var file.
	set -l file $_flag_using_file
	if [ (count $file) -eq 0 ]
		set -l tty (string replace --regex '^/dev/([a-z0-9]+)' '$1' -- (tty))
		set file "$TMPDIR/fish_session_var/$tty"

		# Create the file if it doesn't exist.
		if ! [ -f "$tty" ]
			set -l file_dir (dirname -- "$file")
			if ! [ -d "$file_dir" ]
				mkdir -p -m 700 "$file_dir"
			end

			touch "$file"
			chmod 700 "$file"
		end
	end

	# Flag: --file
	if [ -n "$_flag_file" ]
		echo "$file"
		return 0
	end

	# Flag: --list-with-values
	# Usage: session_var --list-with-values
	#
	# Lists all session variables with their values.
	if [ -n "$_flag_list_with_values" ]
		begin
			if [ (count $_flag_without) -gt 0 ]
				set -l without_key
				set -l without_var
				while read line
					[ -n "$line" ] || continue

					set -l split (string split --max=1 '=' "$line")
					set -l var_key "$split[1]"
					set -l var_val "$split[2]"
					set -l var_mode ""

					# Parse out the var mode (if one is set)
					if string match --quiet "* *" -- "$var_key"
						set -l split (string split --max=1 -- ' ' "$var_key")
						set var_key "$split[2]"
					end

					# If it's included in --without, skip it.
					set without_var false
					for without_key in $_flag_without
						if [ "$var_key" = "$without_key" ]
							set without_var true
							break
						end
					end

					# Print it.
					if not $without_var
						printf "%s=%s\n" "$var_key" "$var_val"
					end
				end < "$file" || return 1
				return 0
			else
				cat "$file" || return 1
				return $status
			end
		end | sed '/^$/d; /^#/d'
	end

	# Flag: --list
	# Usage: session_var --list
	#
	# Lists all session variables.
	if [ -n "$_flag_list" ]
		session_var --list-with-values --using-file="$file" \
			(string replace --regex -- '^' '--without=' $_flag_without) \
			| sed 's/^[a-z]\{1,\} //' \
			| cut -d'=' -f1
		return $status
	end

	# Flag: --import-from-file
	# Usage: session_var --import-from-file=FILE
	# 
	# Imports all session variables associated with another tty.
	if [ -n "$_flag_import_from_file" ] || [ -n "$_flag_import_from_tty" ]
		set -l import_file "$_flag_import_from_file"
		if [ -n "$_flag_import_from_tty" ]
			set -l tty (string replace --regex '^/dev/([a-z0-9]+)' '$1' -- "$_flag_import_from_tty")
			set import_file "$TMPDIR/fish_session_var/$tty"
		end

		set -l line
		set -l current_var_key

		# Cache the current session variables that won't be overwritten.
		set -l vars_to_import (session_var --list --using-file="$import_file") || return $status
		set -l vars_and_vals_to_keep (session_var --list-with-values --using-file="$file" \
			(string replace --regex -- '^' '--without=' $vars_to_import)
		) || return $status

		# Load the session variables to import.
		set -l vars_and_vals_to_import (session_var --list-with-values --using-file="$import_file")

		# "Import" the variables from both caches.
		for line in $vars_and_vals_to_keep $vars_and_vals_to_import
			[ -n "$line" ] || continue

			set -l split (string split --max=1 -- '=' "$line")
			set -l var_key "$split[1]"
			set -l var_val_encoded "$split[2]"
			set -l var_mode ""
			set -l set_flags '-g'

			# Parse out the var mode (if one is set)
			if string match --quiet "* *" -- "$var_key"
				set -l split (string split --max=1 -- ' ' "$var_key")
				set var_mode "$split[1] "
				set var_key "$split[2]"
				switch "$var_mode"
					case "export "
						set set_flags '-gx'
					case "*"
						echo "session_var: unknown variable mode '$var_mode'" 1>&2
				end
			end

			# Decode the variable.
			set -l var_val (string replace --regex --all '\\\\([\\\\ ])' '$1' -- (
				string split "\n" -- "$var_val_encoded"
			))

			# Set the variable.
			set "$set_flags" "$var_key" $var_val
			printf "%s%s=%s\n" "$var_mode" "$var_key" "$var_val_encoded"
		end > "$file"
		
		return 0
	end

	# Flag: --clear
	# Usage: session_var --clear
	#
	# Erases all session variables.
	if [ -n "$_flag_clear" ]
		set -l var_key
		for var_key in (session_var --list --using-file="$file")
			set -ge "$var_key"
		end
		printf "" > "$file"
		return 0
	end

	# Flag: --erase
	# Usage: session_var --erase VAR
	# 
	# Erases a session variable.
	if [ -n "$_flag_erase" ]
		if [ (count $argv) -eq 0 ]
			echo "session_var: erase: variable name missing"
			return 1
		else if [ (count $argv) -gt 1 ]
			echo "session_var: erase: only one variable can be erased at a time"
			return 1
		end

		# Update session file.
		set -l vars (session_var --list-with-values --using-file="$file" --without="$var_key")
		printf "%s\n" $vars > "$file"

		# Update variable.
		set -ge "$argv[1]"
		return 0
	end

	# Flag: --set
	# Usage: session_var --set VAR VALUE1 [VALUE2...]
	if [ -n "$_flag_set" ]
		if [ (count $argv) -eq 0 ]
			echo "session_var: set: variable name missing"
			return 1
		else if [ (count $argv) -eq 1 ]
			echo "session_var: set: variable value missing"
			return 1
		end

		set -l var_key "$argv[1]"
		set -l var_val $argv[2..-1]
		set -l var_mode ''
		set -l set_flags '-g'
		if [ -n "$_flag_export" ]
			set var_mode 'export '
			set set_flags '-gx'
		end

		# Update session file.
		set -l vars (session_var --list-with-values --using-file="$file" --without="$var_key")
		printf "%s\n" $vars > "$file"
		printf "%s%s=%s\n" "$var_mode" "$var_key" (
			string join "\n" (
				string replace --regex --all '([ \\\\])' '\\\\\\\\$1' -- $var_val
			)
		) >> "$file"
		
		# Update variable.
		set "$set_flags" "$var_key" $var_val
		return 0
	end
end

function __session_var_destroy --on-event "fish_exit"
	set -l file (session_var --file)
	if [ -f "$file" ]
		rm "$file"
	end
end

