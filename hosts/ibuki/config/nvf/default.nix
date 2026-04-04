{ lib, ... }:
let
  # 1. readDir lee ./. y retorna un attrSet de "file.nix" = "fileType"
  # 2. filtramos los attrs por ext `.nix` y tipo "regular" (excluyendo default)
  nixFiles = lib.filterAttrs ( 
    name: type: 
      type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" 
  ) ( builtins.readDir ./. );
in
  builtins.foldl'
  ( acc: filename: acc // ( import ( ./. + "/${filename}" ) { inherit lib; } ) )
  {}
  ( builtins.attrNames nixFiles )
