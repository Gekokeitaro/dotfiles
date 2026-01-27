{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    backend = "podman";
    containers."koboldai" = {
      image = "koboldai/koboldcpp:latest";
      volumes = [ "koboldai:/root/.koboldai" ];
      ports = [ "5001:5001" ];
      autoStart = true;
      environment = {
        KCPP_DONT_TUNNEL= "true";
      };
    };
  };
}
