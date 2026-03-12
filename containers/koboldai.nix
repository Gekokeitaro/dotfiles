{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/lib/koboldai/models 0755 root root -"
    "d /var/lib/koboldai/config 0755 root root -"
    "d /var/lib/koboldai/cache 0755 root root -"
  ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers."koboldai" = {
      image = "koboldai/koboldcpp:latest";
      volumes = [ 
        "/var/lib/koboldai/models:/models"
        "/var/lib/koboldai/config:/config"
        "/var/lib/koboldai/cache:/root/.cache"
      ];
      ports = [ "5001:5001" ];
      autoStart = true;

      extraOptions = [
        "--device=/dev/dri"
        "--group-add=video"
      ];
      environment = {
        KCPP_DONT_TUNNEL = "true";
        KCPP_ARGS = "--model /models/qwen2.5-coder-14b-instruct-q4_k_m.gguf --contextsize 32768 --ropeconfig 0.5 --gpu-layers 48 --batch-size 256 --usevulkan --threads 12";
      };
    };
  };
}
