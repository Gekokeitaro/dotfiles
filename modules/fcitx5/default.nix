{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.fcitx5;
in {
  options.homeModules.fcitx5 = {
    enable = mkEnableOption "enable fcitx5 module";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        addons = with pkgs; [ fcitx5-gtk ];
        waylandFrontend = true;

        settings = import ./settings.nix;
      };
    };
  };
}
