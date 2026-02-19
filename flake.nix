{
  description = "OS config entry point";

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
      lib = nixpkgs.lib;
      
      # From LibrePhoenix repo. Get every host directory to list
      hosts = import ./lib/getHosts.nix {inherit lib; };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        # For every host in hosts return...
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
	        home-manager.users."${host}"= (./hosts + "/${host}/home.nix");
   	      }
	    ];  
	  };
	}) hosts
      );
    };
}
