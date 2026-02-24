{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.lazygit;
in {
  options.homeModules.lazygit = {
    enable = mkEnableOption "enable lazygit module";
  };
  
  config = mkIf cfg.enable {
    programs.lazygit.enable = true;
  };
}
