# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Kubectl get -oyaml with yq and caching.
#
# Synopsis
# --------
#
#     kgoq pod some-pod-1 '.status'
#     kgoq pod/some-pod-1 '.status'
#
# =============================================================================

if ! begin; command -vq yq && command -vq kubectl; end
    return
end

function kgoq --description="Get a kubernetes resource as yaml"
    if test (count $argv) -lt 2
        printf "usage: %s [...] [query]\n" (status function) 1>&2
        return 1
    end

    # Extract arguments.
    set -l query $argv[(count $argv)]
    set -l cli $argv[1..(math (count $argv) - 1)]

    # Create a temporary file to store the query.
    if test -z "$__kgoq_fetch_cache"
        set -g __kgoq_fetch_cache (mktemp)
        function __kgoq_cleanup
            test -n "$__kgoq_fetch_cache" \
                && test -f "$__kgoq_fetch_cache" \
                && rm "$__kgoq_fetch_cache"
        end
    end

    # Fetch new data if it's been over 60 seconds since the last update.
    set -l now (date +%s)
    set -l cachekey (begin
        string join " " "$cli"
        if functions -q kubeswitch
            kubeswitch show
        end
    end | sha1sum)

    if begin test -z "$__kgoq_last_fetch_cli" \
        || test -z "$__kgoq_last_run_time" \
        || test "$__kgoq_last_fetch_cachekey" != "$cachekey" \
        || test $now -gt (math "$__kgoq_last_run_time" + 60)
        end
        set -g __kgoq_last_fetch_cachekey "$cachekey"
        kubectl get -oyaml $cli > "$__kgoq_fetch_cache" || return $status
    end

    set -g __kgoq_last_run_time $now

    # Run the query.
    if test -t 1
        yq --colors "$query" "$__kgoq_fetch_cache" | less -R --quit-if-one-screen
    else
        yq "$query" "$__kgoq_fetch_cache"
    end
end


# Completions for 'kgoq'.
complete -c "kgoq" -e
complete -c "kgoq" -f -k -a '(complete --do-complete (printf "kubectl get %s" (commandline -p | cut -d" " -f 2-)))'
