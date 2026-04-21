{ config, lib, ... }:

let
  baseDir = "${config.home.homeDirectory}/.local/share/qdrant";
in
{
  options.containers.qdrant = {
    enable = lib.mkEnableOption "Levantar contenedor de qdrant";

    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "API key para autenticación. null = sin auth (solo red local)";
    };

    restPort = lib.mkOption {
      type = lib.types.port;
      default = 6333;
      description = "Puerto REST + Web UI";
    };

    grpcPort = lib.mkOption {
      type = lib.types.port;
      default = 6334;
      description = "Puerto gRPC";
    };
  };

  config = lib.mkIf config.containers.qdrant.enable {
    homeModules.podman.enable = true;

    systemd.user.tmpfiles.rules = [
      "d ${baseDir} 0755 - - - -"
    ];

    homeModules.podman.containers = {
      "qdrant" = {
        image = "docker.io/qdrant/qdrant:v1.13.4";
        autoStart = true;
        network = "pmnet";

        ports = [
          "0.0.0.0:${toString config.containers.qdrant.restPort}:6333"
          "0.0.0.0:${toString config.containers.qdrant.grpcPort}:6334"
        ];

        environment = lib.mkMerge [
          {
            QDRANT__SERVICE__HOST = "0.0.0.0";
            QDRANT__LOG_LEVEL = "INFO";
          }
          (lib.mkIf (config.containers.qdrant.apiKey != null) {
            QDRANT__SERVICE__API_KEY = config.containers.qdrant.apiKey;
          })
        ];

        volumes = [
          "${baseDir}:/qdrant/storage"
        ];
      };
    };
  };
}