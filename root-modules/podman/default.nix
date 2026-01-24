{pkgs, lib, config, ...}:

{
  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true; 
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
