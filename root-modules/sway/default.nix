{ config, pkgs, lib, ...}:
{
  environment.systemPackages = with pkgs; {
    wl-clipboard
    mako
  };
  
  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
