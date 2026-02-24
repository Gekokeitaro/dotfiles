{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.opencode;
in {
  options.homeModules.opencode = {
    enable = mkEnableOption "enable opencode module";
  };

  config = mkIf cfg.enable {
    programs.opencode.enable = true;
    #homeModules.opencode.settings.default_agent = "plan";
  };
}
