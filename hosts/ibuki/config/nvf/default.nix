{ lib, ... }:
let
  # 1. readDir lee ./. y retorna un attrSet de "file.nix" = "fileType"
  # 2. filtramos los attrs por ext `.nix` y tipo "regular" (excluyendo default)
  nixFiles = lib.filterAttrs ( 
    name: type: 
      type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" 
  ) ( builtins.readDir ./. );
in
  # 1. `attrNames` extrae las claves de nixFiles, ordenadas alfabéticamente.
  # 2. `map` importa el contenido de cada `.nix` como lista
  # 3. Convertimos la lista en attrSet "name" = value
  builtins.listToAttrs ( map ( filename: {
    name = lib.removeSuffix ".nix" filename;
    value = import ( ./. + "/${filename}" ) { inherit lib; };
  }) ( builtins.attrNames nixFiles ))
