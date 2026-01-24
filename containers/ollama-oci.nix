{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    backend = "podman";
    containers."ollama" = {
      image = "ollama/ollama:latest";
      ports = [ "11434:11434" ];
      volumes = [ "ollama:/root/.ollama" ];
      autoStart = true;
    };
  };
}
