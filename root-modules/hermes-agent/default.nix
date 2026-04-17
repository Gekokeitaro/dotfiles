{ lib, config, inputs, ... }:

with lib;

let
  cfg = config.rootModules.hermes-agent;
in {
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  options.rootModules.hermes-agent = {
    enable = mkEnableOption "enable hermes-agent root module";

    defaultModel = mkOption {
      type = types.str;
      description = "Default model to use with hermes-agent";
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "List of environment files to load";
    };
  };
  
  config = mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      settings.model.default = cfg.defaultModel;
      environmentFiles = cfg.environmentFiles;
      addToSystemPackages = true;
    };
  };
}
