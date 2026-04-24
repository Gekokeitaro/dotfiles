{ config, lib, ... }:

with lib;

let
  baseDir = "${config.home.homeDirectory}/.local/share/lightrag";
in
  {
  options.containers.lightrag = {
    enable = mkEnableOption "Levantar contenedor de lightrag";
    neo4j-passwd = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Neo4J password";
    };
  };

  config = mkIf config.containers.lightrag.enable {
    homeModules.podman.enable = true;

    systemd.user.tmpfiles.rules = [
      "d ${baseDir}         0755 - - - -"
      "d ${baseDir}/data    0755 - - - -"
    ];

    homeModules.podman.containers = {
      "lightrag" = {
        image = "ghcr.io/hkuds/lightrag:latest";
        autoStart = true;
        network = "pmnet";

        ports = [
          "0.0.0.0:9621:9621"
        ];

        environment = {
          LIGHTRAG_VECTOR_STORAGE="QdrantVectorDBStorage";
          LIGHTRAG_GRAPH_STORAGE="Neo4JStorage";
          QDRANT_URL="http://qdrant:6333";
          NEO4J_URI="bolt://neo4j:7687";

          LLM_BINDING="openai";
          LLM_MODEL="gemma-4-E4B-it-UD-Q4_K_XL";
          LLM_BINDING_HOST="http://llama-swap:8080/v1";

          EMBEDDING_BINDING="openai";
          EMBEDDING_MODEL="Qwen3-Embedding-0.6B-Q8_0";
          EMBEDDING_BINDING_HOST="http://llama-swap:8080/v1";
          EMBEDDING_DIM="1024";

          OPENAI_API_KEY="sk-dummy-key-for-lightrag";

          NEO4J_USERNAME="neo4j";
          NEO4J_PASSWORD="${config.containers.lightrag.neo4j-passwd}";
          NEO4J_DATABASE="neo4j";
          NEO4J_MAX_CONNECTION_POOL_SIZE="50";
          NEO4J_CONNECTION_TIMEOUT="30";
          NEO4J_CONNECTION_ACQUISITION_TIMEOUT="60";
          NEO4J_MAX_TRANSACTION_RETRY_TIME="30";
          NEO4J_MAX_CONNECTION_LIFETIME="3600";
          NEO4J_LIVENESS_CHECK_TIMEOUT="30";
          NEO4J_KEEP_ALIVE="true";
        };

        volumes = [
          "${baseDir}/data:/data"
        ];
      };
    };
  };
}
