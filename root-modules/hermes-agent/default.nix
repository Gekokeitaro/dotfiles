{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.rootModules.hermes-agent;
in {
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  options.rootModules.hermes-agent = {
    enable = mkEnableOption "enable hermes-agent module";
  };
  
  config = mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      settings.model.default = "openrouter/elephant-alpha";
      environmentFiles = [ config.sops.secrets.openrouter_api_key.path ];
      addToSystemPackages = true;
    };
  };
}
