# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/nektos/act
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.github-act;
  cfgGlobal = config.my-dotfiles.global;
in
{
  options.my-dotfiles.github-act = {
    enable = lib.mkEnableOption "install and configure act, the local GitHub Actions runner";

    package = lib.mkOption {
      type = lib.types.package;
      description = "the act package to install";
      default = pkgs-unstable.act;
    };

    githubEnterpriseHostname = lib.mkOption {
      type = lib.types.str;
      description = "the hostname of the GitHub Enterprise instance, if using one";
      default = "";
      example = "github.my-company.com";
    };

    containerArchitecture = lib.mkOption {
      type = lib.types.str;
      description = "the container architecture to use for runners";
      default = "";
      example = "linux/amd64";
    };

    runnerImages = lib.mkOption {
      type = lib.types.attrsOf (lib.types.str);
      description = "the available runners (platforms) and their Docker images";
      default = { };
      example = {
        "ubuntu-18.04" = "nektos/act-environments-ubuntu:18.04";
      };
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      description = "extra values to add to `.actrc`";
      default = "";
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install the `act` command for running GitHub Actions locally.
    {
      home.packages = [
        cfg.package
      ];

      # Add it as a `gh` alias, `gh act`.
      programs.gh.settings.aliases = {
        act = "!act";
      };

      # Configure act.
      home.file =
        let
          maybeCreateFlag = flag: value: if value == "" then "" else "${flag} ${value}";

          extraConfig =
            if cfg.extraConfig == ""
            then ""
            else "# Extra configuration:\n${extraConfig}";

          # Build the `--platform` flags:
          runnerImagesFlags =
            if (builtins.length (builtins.attrNames cfg.runnerImages)) == 0
            then ""
            else
              lib.strings.concatMapStringsSep
                "\n"
                (name: "--platform ${name}=${cfg.runnerImages.${name}}")
                (builtins.attrNames cfg.runnerImages);

          # Build simple flags:
          containerArchFlag = maybeCreateFlag "--container-architecture" cfg.containerArchitecture;
          githubInstanceFlag = maybeCreateFlag "--github-instance" cfg.githubEnterpriseHostname;

          # Combine everything:
          configContents = lib.strings.concatStringsSep "\n" (builtins.filter (it: it != "") [
            runnerImagesFlags
            containerArchFlag
            githubInstanceFlag
            extraConfig
          ]);

        in
        if configContents == ""
        then { }
        else {
          ".actrc".text = "${configContents}\n";
        };

    }

  ]);
}
