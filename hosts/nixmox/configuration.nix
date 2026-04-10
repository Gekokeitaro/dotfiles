{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../root-modules
      #../../containers/llama-swap.nix
    ];

  rootModules.podman.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    networkmanager.enable = true;
    hostName = "nixmox"; # Define your hostname.
    firewall.allowedTCPPorts = [ 5001];
  };

  time.timeZone = "Europe/Madrid";

  # Layout del teclado en español para la terminal
  console.keyMap = "es";

  services.xserver = {
    enable = true;
    xkb.layout = "es"; # Layout del teclado en español para UI
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
  };

  services.displayManager.ly.enable = true;
	
  users.users.nixmox= {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
  
  fonts.packages = with pkgs; [
    nerd-fonts.fira-mono
  ];

  hardware.graphics.enable = true;
  hardware.firmware = [ pkgs.linux-firmware ];  # firmwares yellow_carp_*.bin para Radeon 680M (Rembrandt)

  # Configuración SSH
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false; # True la primera vez para añadir las claves SSH
      AllowUsers = [ "nixmox" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 5d";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

