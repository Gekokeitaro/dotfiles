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
        koboldcpp = {
          npm = "@ai-sdk/openai-compatible";
          name = "KoboldCPP";
          options = {
            baseURL = "http://192.168.18.3:5001/v1";
          };
          models = {
            "koboldcpp/qwen2.5-coder-14b-instruct-q4_k_m" = {
              name = "Qwen 2.5 Coder 14B";
            };
          };
        };
      };
    };
  };
}
