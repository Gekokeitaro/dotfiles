{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.opencode;
in {
  options.homeModules.opencode = {
    enable = mkEnableOption "enable opencode module";
  };

  config = mkIf cfg.enable {
    programs.opencode.enable = true;
    programs.opencode.settings = {
      default_agent = "plan";
      plugin = [ "opencode-models-discovery" "@omniroute/opencode-plugin" "@vectorize-io/opencode-hindsight"];
      provider = {
        omniroute = {
          npm = "@ai-sdk/openai-compatible";
          name = "omniroute (local)";
          options = {
            baseURL = "http://192.168.18.32:20128/v1";
            apiKey = "sk-325a74ece6465768-baf160-daf9ba62";
          };
        };
        llama-swap = {
          npm = "@ai-sdk/openai-compatible";
          name = "llama-swap (local)";
          options = {
            baseURL = "http://192.168.18.12:8080/v1";
            modelsDiscovery = { enabled = true; };
          };
        };
      };
    };
  };
}
