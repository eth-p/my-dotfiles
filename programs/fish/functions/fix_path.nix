{ name, ... }:
''
  # MacOS has a special path_helper executable that will push any path not
  # specified in `/etc/paths` or `/etc/paths.d` to the very end of the PATH
  # environment variable.
  #
  # Fish recreated the logic and includes it in its internal config script.
  # This causes some problems with undesired path suffling and reordering,
  # and the only consistent fix is to throw away the entire thing and start
  # over from scratch.

  function ${name} \
  --description "reconstruct the PATH variable"
    set -l --path system_paths \
      /usr/local/bin /usr/local/sbin \
      /usr/bin /usr/sbin \
      /bin /sbin

    # Find the fastest sh-compatible shell.
    set -l sh_progs (command -v /bin/dash /bin/sh)
    set -l sh $sh_progs[1]

    # If `path_helper` exists, use it to get the system paths.
    if command -vq '/usr/libexec/path_helper'
      set system_paths (PATH='/bin' '/usr/libexec/path_helper' | $sh -c '. /dev/stdin && echo "$PATH"')
    end

    # If nix is installed, get its profile paths.
    set -l --path nix_paths
    set -l profile_file
    for profile_file in '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' \
      '/nix/var/nix/profiles/default/etc/profile.d/nix.sh'
      if test -e "$profile_file"
        set -e __ETC_PROFILE_NIX_SOURCED
        set nix_paths ($sh -c "PATH=""; . '$profile_file' && echo \"\$PATH\"" | string trim -lr -c':')
        break
      end
    end

    # If we have any nix store paths from the current PATH, get them.
    # These would come from `nix develop` or `devenv`.
    set -l --path nix_store_paths (string match -- '/nix/store/**/*' $PATH)

    # If home-manager is installed, get its paths.
    set -l --path hm_paths
    set -l hm_session_vars_file "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    if test "$nix_paths" != "" && test -e "$hm_session_vars_file"
      set hm_paths ($sh -c "PATH=""; . '$hm_session_vars_file' && echo \"\$PATH\"")
    end

    # Combine everything in a sane order.
    #  1. nix store (i.e. nix shell)
    #  2. fish_user_paths
    #  3. ~/.local/bin
    #  4. home-manager
    #  5. nix
    #  6. homebrew
    #  7. system
    set -g PATH
    test "$nix_store_paths" != "" && set --append PATH $nix_store_paths
    test "$fish_user_paths" != "" && set --append PATH (string split ":" -- $fish_user_paths)
    test -d "$HOME/.local/bin"    && set --append PATH "$HOME/.local/bin"
    test "$hm_paths"        != "" && set --append PATH $hm_paths
    test "$nix_paths"       != "" && set --append PATH $nix_paths
    test -d /opt/homebrew/bin     && set --append PATH /opt/homebrew/bin

    set -l system_path_entry
    for system_path_entry in $system_paths
      if not contains $system_path_entry $xPATH
        set --append PATH $system_path_entry
      end
    end

    set -gx __ETHP_FIXED_PATH true
  end
''
