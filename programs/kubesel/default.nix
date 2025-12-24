# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/eth-p/kubesel
# ==============================================================================
{
  lib,
  config,
  pkgs,
  my-dotfiles,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib) togotemplate;
  cfg = config.my-dotfiles.kubesel;
  cfgGlobal = config.my-dotfiles.global;
in
{
  options.my-dotfiles.kubesel = {
    enable = lib.mkEnableOption "install kubesel";

    kubeconfigs = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "glob pattern matching kubeconfig files";
      example = "~/.kube/configs/*.yaml";
    };

    inPrompt = lib.mkEnableOption "show kubesel info in the shell prompt";

    inPromptClusterOverrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "override the name or color for specific clusters";
      example = {
        "docker-desktop" = {
          name = "docker";
          fg = "#FFFFFF";
          bg = "#1D63ED";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install kubesel.
    (
      let
        system = pkgs.stdenv.hostPlatform.system;
        kubesel = my-dotfiles.inputs.kubesel.packages.${system}.kubesel;
      in
      {
        home.packages = [
          kubesel
        ];

        programs.fish.interactiveShellInit = ''
          # Initialize kubesel.
          ${kubesel.out + /bin/kubesel} init fish ${
            if cfg.kubeconfigs == null then "" else "--add-kubeconfigs='${cfg.kubeconfigs}'"
          } | source
        '';
      }
    )

    # Configure oh-my-posh to show kubernetes info.
    (mkIf cfg.inPrompt {
      my-dotfiles.oh-my-posh.extraBlocks.kubernetes =
        let
          icons =
            if cfgGlobal.nerdfonts then
              {
                leading = " "; # e81d (kubernetes)
                trailing = "";
              }
            else
              {
                leading = "";
                trailing = "³";
              };

          # raiseAttr picks a property from an attribute set and raises it.
          # Example: `"bar" {foo = { bar = "baz" }} -> { foo = "baz" }
          raiseAttr =
            name: attrs:
            builtins.listToAttrs (
              map (k: {
                name = k;
                value = attrs.${k}.${name};
              }) (builtins.attrNames attrs)
            );

          fgColorLUT = raiseAttr "fg" cfg.inPromptClusterOverrides;
          bgColorLUT = raiseAttr "bg" cfg.inPromptClusterOverrides;
          nameLUT = raiseAttr "name" cfg.inPromptClusterOverrides;
        in
        {
          priority = 50;

          type = "prompt";
          alignment = "left";
          leading_diamond = " ";
          trailing_diamond = "";

          segments = [
            {
              type = "kubectl";

              foreground_templates = [
                "{{- $lut := ${togotemplate.attrs fgColorLUT} }}{{ (get $lut .Cluster | default \"\") }}"
                "p:kubectl_fg"
              ];
              background_templates = [
                "{{- $lut := ${togotemplate.attrs bgColorLUT} }}{{ (get $lut .Cluster | default \"\") }}"
                "p:kubectl_bg"
              ];

              style = "diamond";
              leading_diamond = " ";
              trailing_diamond = "";

              options = {
                cluster_aliases = nameLUT;
              };

              template = (
                builtins.concatStringsSep "" [
                  " ${icons.leading}{{.Cluster}}{{if .Namespace}}/{{.Namespace}}{{end}}${icons.trailing} "
                ]
              );

              properties = {
                parse_kubeconfig = true;
              };
            }
          ];

        };
    })
  ]);
}
