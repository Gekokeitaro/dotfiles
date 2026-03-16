{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.ghostty;
in {
  options.homeModules.ghostty = {
    enable = mkEnableOption "enable ghostty module";
  };

  config = mkIf cfg.enable {
    programs.ghostty.enable = true;
  };
}
