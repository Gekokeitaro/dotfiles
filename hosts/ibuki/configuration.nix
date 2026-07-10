{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../root-modules
    ];

  rootModules.sops = {
    enable = true;
    defaultSopsFile = ../../secrets/common/system.yaml;
    keyFile = "/home/ibuki/.config/sops/age/keys.txt";
    secrets."hermes-env" = { format = "yaml"; };
  };
  
  rootModules.hermes-agent = {
    enable = true;
    providerUrl = "http://192.168.18.108:8080/v1";
    defaultModel = "gemma-4-E4B-it-qat-UD-Q4_K_XL";
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ibuki"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";
  console.keyMap = "es";
  i18n.defaultLocale = "es_ES.UTF-8";

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "''${pkgs.tuigreet}/bin/tuigreet --time  --asterisks --user-menu --cmd sway";
          user = "greeter";
        };
      };
    };

    # Battery
    tlp.enable = true;
    thermald.enable = true;
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';
	
  users.users.ibuki= {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "hermes" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    #vim
    wget
    git
    magic-wormhole
    fastfetch
    tealdeer
    pi-coding-agent
    tuigreet
  ];
  
  fonts.packages = with pkgs; [
    cozette
    nerd-fonts.proggy-clean-tt
  ];

  # Configuración SSH
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false; # True la primera vez para añadir las claves SSH
      AllowUsers = [ "ibuki" ];
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

