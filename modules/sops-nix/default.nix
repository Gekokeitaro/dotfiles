{ lib, config, inputs, ... }:

with lib;

let
  cfg = config.homeModules.sops;
in {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  options.homeModules.sops = {
    enable = mkEnableOption "Enable sops-nix as home-manager module";

    defaultSopsFile = mkOption {
      type = types.path;
      description = "Path to default sops file";
    };

    keyFile = mkOption {
      type = types.str;
      description = "Absolute path to the age key file";
    };

    secrets = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
      description = "Secrets to declare for sops";
    };
    
    templates = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
      description = "Templates to declare for sops";
    };
  };

  config = mkIf cfg.enable {
    sops.defaultSopsFile = cfg.defaultSopsFile;
    sops.age.keyFile = cfg.keyFile;
    sops.secrets = cfg.secrets;
    sops.templates = cfg.templates;
  };
}
