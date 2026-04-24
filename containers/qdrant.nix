{ config, lib, ... }:

let
  baseDir = "${config.home.homeDirectory}/.local/share/qdrant";
in
{
  options.containers.qdrant = {
    enable = lib.mkEnableOption "Levantar contenedor de qdrant";
  };

  config = lib.mkIf config.containers.qdrant.enable {
    homeModules.podman.enable = true;

    systemd.user.tmpfiles.rules = [
      "d ${baseDir} 0755 - - - -"
    ];

    homeModules.podman.containers = {
      "qdrant" = {
        image = "qdrant/qdrant:latest";
        autoStart = true;
        network = "pmnet";

        ports = [
          "0.0.0.0:6333:6333"
          "0.0.0.0:6334:6334"
        ];

        environment = lib.mkMerge [];

        volumes = [
          "${baseDir}:/qdrant/storage"
        ];
      };
    };
  };
}
