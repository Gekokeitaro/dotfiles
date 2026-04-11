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
      provider = {
        llama-swap = {
          npm = "@ai-sdk/openai-compatible";
          name = "llama-swap (local)";
          options = {
            baseURL = "http://192.168.18.3:8080/v1";
          };
          models = {
            "gpt-oss-20b-NEO-IQ4_NL" = {
              name = "GPT OSS 20b NEO IQ4_NL";
            };
            "gpt-oss-20b-NEO-IQ4_NL:low" = {
              name = "GPT OSS 20b NEO IQ4_NL (low)";
            };
            "gpt-oss-20b-NEO-IQ4_NL:high" = {
              name = "GPT OSS 20b NEO IQ4_NL (high)";
            };
            "qwen3.5-9b-claude-4.6-uncensored-thinking" = {
              name = "Qwen3.5 9b + Claude4.6 uncensored (thinking)";
            };
         };
        };
      };
    };
  };
}
