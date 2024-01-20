#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#    A library of bash functions for interfacing with Flatpak.
#
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This library of functions is sourced by other executable bash scripts
#   as a way to interface with Flatpak and its running instances.
#
# =============================================================================

# Prints the Flatpak runtime directory.
#
# Synopsis:
#   flatpak:get_rundir
#
# Options:
#   (none)
#
# Return:
#   0                     -- The Flatpak rundir.
#   1                     -- If the rundir could not be found.
#   10                    -- Invalid argument(s).
flatpak:get_rundir() {
    if [[ "$#" -ne 0 ]]; then
        return 10
    fi

    # Determine the rundir.
    # This is probably `${XDG_RUNTIEM_DIR}/.flatpak`.
    local rundir="${XDG_RUNTIME_DIR:-/var/run}/.flatpak"
    if [[ -d "$rundir" ]]; then
        printf "%s\n" "$rundir"
        return 0
    fi

    # Could not determine the rundir.
    return 1
}

# Checks if a Flatpak instance is a Chrome/Chromium sandbox instance.
#
# Purpose:
#   Chromium/CEF-based applications spawn an additional flatpak instance with
#   all permissions dropped. These instances can be differentiated by the
#   `SBX_CHROME_API_PRV=1` environment variable under the instance `info` file.
#
# Synopsis:
#   flatpak:is_chrome_sandbox [options] <InstanceID>
#
# Options:
#   --rundir=<dir>        -- The Flatpak rundir.
#
# Return:
#   0                     -- The instance is a Chrome sandbox.
#   1                     -- The instance is not a Chrome sandbox.
#   10                    -- Invalid argument(s).
#   11                    -- Invalid InstanceID.
flatpak:is_chrome_sandbox() {
    local args=()
    local opt_rundir=''
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --rundir=*) opt_rundir="${1:9}" ;;
            -*) return 10 ;;
            *)  args+=("$1") ;;
        esac
        shift
    done

    if [[ -z "$opt_rundir" ]]; then
        opt_rundir="$(flatpak:get_rundir)"
    fi

    if [[ "${#args[@]}" -ne 1 ]]; then
        return 10
    fi

    # Ensure the instance exists.
    local info_file="${opt_rundir}/${args[0]}/info"
    if ! [[ -f "$info_file" ]]; then
        return 11
    fi

    # Check if the instance is a Chrome/Chromium sandbox.
    awk 'BEGIN{p=0} {if(p){ print $0 }} /^\[/{if(p){exit}} /^\[Environment\]$/{p=1}' "$info_file" \
        | grep -Fx 'SBX_CHROME_API_PRV=1' &>/dev/null \
        || return 1
}

# Checks if a Flatpak is currently running.
#
# Synopsis:
#   flatpak:is_running <ID>
#
# Options:
#   (none)
#
# Return:
#   0                     -- A Flatpak with the provided ID is running.
#   1                     -- A Flatpak with the provided ID is not running.
#   10                    -- Invalid argument(s).
flatpak:is_running() {
    local args=()
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -*) return 10 ;;
            *)  args+=("$1") ;;
        esac
        shift
    done

    # Validate.
    if [[ "${#args[@]}" -ne 1 ]]; then
        return 10
    fi

    # Check `flatpak ps`.
    flatpak ps --columns=application \
        | grep -Fx "${args[0]}" &>/dev/null \
        || return 1
}

# Prints the instance IDs of one or more running Flatpak application(s).
#
# Synopsis:
#   flatpak:instances [options] <ID|InstanceID...>
#
# Options:
#   -a    --all           -- Show all instance IDs, even Chrome sandboxes.
#
# Outputs:
#   STDOUT                -- The instance ID(s).
#
# Return:
#   0                     -- Success.
#   1                     -- No matching Flatpak instances were found.
#   10                    -- Invalid argument(s).
flatpak:instances() {
    local opt_all=false
    local args=()
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -a|--all) opt_all=true ;;
            -*) return 10 ;;
            *)  args+=("$1") ;;
        esac
        shift
    done

    # Validate.
    if [[ "${#args[@]}" -eq 0 ]]; then
        return 10
    fi

    # Read the instance IDs from `flatpak ps`.
    local instances=()
    local instance_id
    local query
    while read -r instance_id application; do
        for query in "${args[@]}"; do
            if [[ "$query" = "$instance_id" || "$query" = "$application" ]]; then
                instances+=("$instance_id")
            fi
        done
    done < <(flatpak ps --columns=instance,application)

    # Return 1 if there were no instances.
    if [[ "${#instances[@]}" -eq 0 ]]; then
        return 1
    fi

    # Print all instances if `--all` was provided.
    if "$opt_all"; then
        printf "%s\n" "${instances[@]}"
        return 0
    fi

    # Print only relevant instances.
    local rundir
    rundir="$(flatpak:get_rundir)"
    for instance in "${instances[@]}"; do

        # Skip Chrome/Chromium sandbox instances.
        if flatpak:is_chrome_sandbox --rundir="${rundir}" "$instance"; then
            continue
        fi

        # Print the instance.
        printf "%s\n" "$instance"

    done
    return 0
}

# Prints the PIDs of one or more running Flatpak application(s).
#
# Synopsis:
#   flatpak:pids [options] <ID|InstanceID...>
#
# Options:
#   -a    --all           -- Show all instance IDs, even Chrome sandboxes.
#   --child               -- Print the sandbox child PID.
#   --namespaced          -- Print the sandbox-namespaced PID. (Implies --child)
#
# Outputs:
#   STDOUT                -- The instance ID(s).
#
# Return:
#   0                     -- A Flatpak with the provided ID is running.
#   1                     -- No matching Flatpak instances were found.
#   10                    -- Invalid argument(s).
flatpak:pids() {
    local opt_child=false
    local opt_namespaced=false
    local args_fwd=()
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --child)      opt_child=true ;;
            --namespaced) opt_child=true; opt_namespaced=true ;;
            -a|--all) args_fwd+=("$1") ;;
            -*) return 10 ;;
            *)  args_fwd+=("$1") ;;
        esac
        shift
    done

    # Get the IDs as Flatpak instance IDs and fetch their PIDs.
    local pids=()
    local rundir
    rundir="$(flatpak:get_rundir)"
    while read -r instance; do
        pids+=("$(cat -- "${rundir}/${instance}/pid")")
    done < <(flatpak:instances "${args_fwd[@]}")

    # If the child PID was requested, use `ps` to fetch those.
    if "$opt_child"; then
        local filter="$(printf ',%s' "${pids[@]}")"
        readarray -t pids < <(
            ps --no-headers --ppid="${filter:1}" --format=pid \
                | sed 's/^[ \t]*//'
        )
    fi

    # If the namespaced PID was requested, read `/proc/${PID}/status` to get that.
    if "$opt_namespaced"; then
        local pid
        local i
        for (( i=0; i < ${#pids[@]}; i++ )); do
            pids[i]="$(awk '$1 == "NSpid:" { print $3 }' "/proc/${pids[$i]}/status")"
        done
    fi

    # Print the PIDs.
    printf "%s\n" "${pids[@]}"
}
