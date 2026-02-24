{ lib, path }:

builtins.filter (x: x != null) (
  lib.mapAttrsToList 
  (name: value: if value == "directory" then name else null) 
  ( builtins.readDir path )
)
