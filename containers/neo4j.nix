{ config, lib, ... }:

with lib;

let
  baseDir = "${config.home.homeDirectory}/.local/share/neo4j";
in
  {
  options.containers.neo4j = {
    enable = mkEnableOption "Levantar contenedor de neo4j";

    username = mkOption {
      type = types.str;
      default = "neo4j";
      description = "Usuario inicial de Neo4j";
    };

    password = mkOption {
      type = types.str;
      default = "neo4j";
      description = "Contraseña inicial de Neo4j";
    };
  };

  config = mkIf config.containers.neo4j.enable {
    homeModules.podman.enable = true;

    systemd.user.tmpfiles.rules = [
      "d ${baseDir}         0755 - - - -"
      "d ${baseDir}/data    0755 - - - -"
    ];

    homeModules.podman.containers = {
      "neo4j" = {
        image = "neo4j:community-ubi10";
        autoStart = true;
        network = "pmnet";

        ports = [
          "0.0.0.0:7474:7474"
          "0.0.0.0:7687:7687"
        ];

        environment = {
          NEO4J_AUTH = "${config.containers.neo4j.username}/${config.containers.neo4j.password}";
        };

        volumes = [
          "${baseDir}/data:/data"
        ];
      };
    };
  };
}
