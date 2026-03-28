{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.pico8;
  pico8Pkg = pkgs.writeShellScriptBin "pico8" ''
    if [ ! -x "${cfg.binaryPath}" ]; then
      echo "PICO-8 no encontrado o no ejecutable en: ${cfg.binaryPath}"
      exit 1
    fi

    exec ${ pkgs.buildFHSEnv {
      name = "pico8-fhs";
      targetPkgs = pkgs: with pkgs; [
        libx11
        libxext
        libxcursor
        libxinerama
        libxi
        libxrandr
        libxscrnsaver
        libxxf86vm
        libxcb
        libxrender
        libxfixes
        libxau
        libxdmcp
        alsa-lib
        udev
        wget
        apulse
      ];
      
      runScript = pkgs.writeShellScript "pico8-runner" ''
        exec "$@"
      '';

    }}/bin/pico8-fhs "${cfg.binaryPath}" "$@"
  '';
in {
  options.homeModules.pico8 = {
    enable = lib.mkEnableOption "PICO-8";

    binaryPath = lib.mkOption {
      type = lib.types.str;
      example = "$HOME/.local/share/pico8/pico8";
      description = "Ruta al binario de PICO-8";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pico8Pkg ];
  };
}

