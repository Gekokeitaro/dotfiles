{ lib }:
let
  hostsDir = ../hosts;
in
builtins.filter (x: x != null) (
  lib.mapAttrsToList 
  (name: value: if value == "directory" then name else null) 
  ( builtins.readDir hostsDir )
)
