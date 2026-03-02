{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  moduleList = import ../utils/getDirs.nix { inherit lib; path=./.;};
in {
  imports = map( module: ./. + "/${module}" ) moduleList;
}
