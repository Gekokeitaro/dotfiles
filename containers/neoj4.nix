{ config, lib, ... }:

let
  baseDir = "${config.home.homeDirectory}/.local/share/neo4j";
in
{
  options.containers.neo4j = {
    enable = lib.mkEnableOption "Levantar contenedor de neo4j";

    auth = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "neo4j";
        description = "Usuario inicial de Neo4j";
      };

      # Usa un secreto o variable de entorno en producción
      password = lib.mkOption {
        type = lib.types.str;
        default = "neo4j_password";
        description = "Contraseña inicial";
      };
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 7474;
      description = "Puerto HTTP (Neo4j Browser)";
    };

    boltPort = lib.mkOption {
      type = lib.types.port;
      default = 7687;
      description = "Puerto Bolt (protocolo de queries)";
    };
  };

  config = lib.mkIf config.containers.neo4j.enable {
    homeModules.podman.enable = true;

    systemd.user.tmpfiles.rules = [
      "d ${baseDir}         0755 - - - -"
      "d ${baseDir}/data    0755 - - - -"
      "d ${baseDir}/logs    0755 - - - -"
      "d ${baseDir}/import  0755 - - - -"
      "d ${baseDir}/plugins 0755 - - - -"
    ];

    homeModules.podman.containers = {
      "neo4j" = {
        image = "docker.io/library/neo4j:5-community";
        autoStart = true;
        network = "pmnet";

        ports = [
          "0.0.0.0:${toString config.containers.neo4j.httpPort}:7474"
          "0.0.0.0:${toString config.containers.neo4j.boltPort}:7687"
        ];

        environment = {
          # Acepta la licencia de Community Edition
          NEO4J_ACCEPT_LICENSE_AGREEMENT = "eval";

          # Auth: formato "usuario/contraseña"
          NEO4J_AUTH = "${config.containers.neo4j.auth.username}/${config.containers.neo4j.auth.password}";

          # Escucha en todas las interfaces dentro del contenedor
          NEO4J_server_default__listen__address = "0.0.0.0";

          # Heap — ajusta según RAM disponible
          NEO4J_server_memory_heap_initial__size = "512m";
          NEO4J_server_memory_heap_max__size = "1g";
          NEO4J_server_memory_pagecache__size = "512m";
        };

        volumes = [
          "${baseDir}/data:   /data"
          "${baseDir}/logs:   /logs"
          "${baseDir}/import: /var/lib/neo4j/import"
          "${baseDir}/plugins:/plugins"
        ];
      };
    };
  };
}