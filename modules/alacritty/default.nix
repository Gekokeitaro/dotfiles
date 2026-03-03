{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.alacritty;
in {
  options.homeModules.alacritty = {
    enable = mkEnableOption "enable alacritty module";
  };

  config = mkIf cfg.enable {
    programs.alacritty.enable = true;
  };
}
