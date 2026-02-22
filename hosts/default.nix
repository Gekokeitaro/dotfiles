{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  hostsDirs = import ../lib/getHosts.nix { inherit lib; };
in
builtins.listToAttrs (
  map ( host: {
    name = host;
    value = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (./. + "/${host}/configuration.nix")
        inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users."${host}" = (./. + "/${host}/home.nix");
        }
      ];
    };
  }) hostsDirs
)
