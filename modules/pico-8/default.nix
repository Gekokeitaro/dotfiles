{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.pico8;
  pico8Pkg = pkgs.writeShellScriptBin "pico8" ''
    if [! -x "${cfg.binaryPath}" ]; then
      echo "PICO-8 no encontrado o no ejecutable en: ${cfg.binaryPath}"
      exit 1
    fi

    exec ${ pkgs.buildFHSUserEnv {
      name = "pico8-fhs";
      targetPkgs = pkgs: with pkgs; [
        xorg.libX11
        xorg.libXext
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXi
        xorg.libXrandr
        xorg.libXScrnSaver
        xorg.libXxf86vm
        xorg.libxcb
        xorg.libXrender
        xorg.libXFixes
        xorg.libXau
        xorg.libXdmcp
        alsa-lib
        udev
        wget
      ];
      
      runScript = "bash";
    }}/bin/pico8-fhs -- "${cfg.binaryPath}" "$@"
  '';
in {
  options.programs.pico8 = {
    enable = lib.mkEnableOption "PICO-8";

    binaryPath = lib.mkOption {
      type = lib.types.path;
      example = "$HOME/.local/share/pico8/pico8";
      description = "Ruta al binario de PICO-8";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pico8Pkg ];
  };
}

