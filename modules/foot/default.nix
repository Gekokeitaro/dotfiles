{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.foot;
in {
  options.homeModules.foot = {
    enable = mkEnableOption "enable foot module";
  };
  
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          font = "Cozette:size=10";
          letter-spacing = "1px";
        };

        colors-dark = {
          alpha = "0.85";
        };
      };
    };
  };
}
