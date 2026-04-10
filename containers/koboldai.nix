{ pkgs, config, ... }:
let

  # Por convención en NixOS, centralizamos los datos del contenedor en /var/lib/
  homelabBaseDir = "/var/lib/n8n-starter";
  sharedDataDir = "${homelabBaseDir}/shared";
  modelsDataDir = "${homelabBaseDir}/models";
  koboldaiAdminDir= "${homelabBaseDir}/kobold-admin";
in
{
  # ==========================================
  # MEJORA: CREACIÓN AUTOMÁTICA DE DIRECTORIOS
  # ==========================================
  systemd.tmpfiles.rules = [
    "d ${homelabBaseDir} 0755 root root -"
    "d ${sharedDataDir} 0755 root root -"
    "d ${modelsDataDir} 0755 root root -" # Creamos obligatoriamente la carpeta física de los modelos
    "d ${koboldaiAdminDir} 0755 root root -"
  ];
  # ==========================================
  # AUTOMATIZACIÓN DE LA RED "nixmox"
  # ==========================================
  systemd.services."create-nixmox-network" = {
    description = "Create OCI network nixmox";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.podman ]; 
    script = ''
      ${pkgs.podman}/bin/podman network inspect nixmox >/dev/null 2>&1 || ${pkgs.podman}/bin/podman network create nixmox
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    before = builtins.map (name: "podman-${name}.service") (builtins.attrNames config.virtualisation.oci-containers.containers);
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.koboldcpp = {
      image = "koboldai/koboldcpp:latest";
      autoStart = true;
      extraOptions = [ 
        "--network=nixmox" 
        # Vulkan utiliza obligatoriamente el renderizador directo, nunca el KFD
        "--device=/dev/dri:/dev/dri"
        "--group-add=video"
      ];
      environment = {
        KCPP_DONT_TUNNEL = "true";
        # Pasamos los comandos de Kobold usando la variable oficial para no romper el ejecutable base (CRUN)
        KCPP_ARGS = "--usevulkan 0 --host 0.0.0.0 --port 5001 --contextsize 32768 --ropeconfig 0.5 10000 --gpulayers 99 --jinja --admin --admindir /admindir --downloaddir /models --routermode --adminunloadtimeout 30 --model /models/openai_gpt-oss-20b-Q6_K_L.gguf";       
        # Una vez que poseas el archivo descargado en /var/lib/n8n-starter/models/, puedes 
        # añadir a KCPP_ARGS "--model /models/tu_modelo.gguf" quitando el param --nomodel
      };
      ports = [ "5001:5001" ];
      volumes = [
        "${modelsDataDir}:/models"
        "${koboldaiAdminDir}:/admindir"
      ];
    };
  };
}
