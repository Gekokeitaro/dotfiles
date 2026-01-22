{pkgs, lib, config, ...}:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  # TODO: Modularize
  users.users.nixmox = { # replace `<USERNAME>` with the actual username
    extraGroups = [
      "podman"
    ];
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
  ];
}
