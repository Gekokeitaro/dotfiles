{
  description = "OS config entry point";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs =
    { self, nixpkgs, ... } @inputs: {
      nixosConfigurations = import ./hosts { inherit inputs; };  
    };
}
