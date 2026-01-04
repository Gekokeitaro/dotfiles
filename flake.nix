{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... } @inputs:
    let
      lib = inputs.nixpkgs.lib;

      hosts = builtins.filter (x: x != null) (
        lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (
	  builtins.readDir ./hosts
	)
      );
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
	  name = host;
	  value = lib.nixosSystem {
            system = "x86_64-linux";
	    modules = [
	      (./hosts + "/${host}/configuration.nix")
	      home-manager.nixosModules.home-manager
	      {
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.users.nixmox = (./hosts + "/${host}/home.nix");
   	      }
	    ];  
	  };
	}) hosts
      );
    };
}
