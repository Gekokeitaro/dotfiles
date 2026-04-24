{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.rclone;
in {
  options.homeModules.rclone = {
    enable = mkEnableOption "Enable Rclone configurations";

    mountPoint = mkOption {
      type = types.str;
      description = "Relative path from $HOME where cloud storage will be mounted";
    };

    remoteName = mkOption {
      type = types.str;
      default = "pcloud";
      description = "";
    };

    remotePath = mkOption {
      type = types.str;
      description = "";
    };

    configPath = mkOption {
      type = types.path;
      description = "Path to the rclone config file (e.g. from sops-nix)";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to an environment file for sensitive variables (e.g. from sops-nix)";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.rclone= {
      Unit = {
        Description = "rclone mount";
        After = [ "network-online.target" "sops-nix.service" ];
        Wants = [ "network-online.target" ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = mkMerge [
        {
          Type = "notify";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/${cfg.mountPoint}";
          ExecStart = ''
            ${pkgs.rclone}/bin/rclone mount ${cfg.remoteName}:${cfg.remotePath} %h/${cfg.mountPoint} \
              --config ${cfg.configPath} \
              --vfs-cache-mode writes \
              --vfs-cache-max-age 1h \
              --allow-other
          '';
          ExecStop = "/run/wrappers/bin/fusermount -u %h/${cfg.mountPoint}";
          Restart = "on-failure";
          RestartSec = "10s";
          Environment = [ "PATH=/run/wrappers/bin:${pkgs.coreutils}/bin" ];
        }
        (mkIf (cfg.environmentFile != null) {
          EnvironmentFile = cfg.environmentFile;
        })
      ];
    };
  };
}

