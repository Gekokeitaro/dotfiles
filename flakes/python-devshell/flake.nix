{
  description = "Python project development shell with UV";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = f: builtins.listToAttrs (map (s: { name = s; value = f s; }) systems);
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "python-uv";
            packages = [ pkgs.uv ];
            shellHook = ''
              echo ""
              echo "🐍 Python + UV dev shell"
              echo ""
              echo "  uv init <nombre>   — Crear un nuevo proyecto"
              echo "  uv add <paquete>   — Añadir una dependencia"
              echo "  uv run <script>    — Ejecutar un script"
              echo "  uv sync            — Sincronizar dependencias"
              echo "  uv python install  — Instalar una versión de Python"
              echo ""
              echo "UV: $(uv --version)"
              echo ""
            '';
          };
        });
    };
}
