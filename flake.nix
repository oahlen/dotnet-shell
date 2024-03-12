{
  description = "Dotnet development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = let
        combined = with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_6_0
            sdk_8_0
          ];
      in
        pkgs.mkShell {
          ASPNETCORE_ENVIRONMENT = "Development";
          DOTNET_ROOT = "${combined}";

          # For GUI based applications
          LD_LIBRARY_PATH = with pkgs;
            lib.makeLibraryPath [
              fontconfig
              libGL
              libxkbcommon
              mono # For certain tools like Microsoft sbom tool
              wayland
              xorg.libICE
              xorg.libSM
              xorg.libX11
              xorg.libXcursor
              xorg.libXi
              xorg.libXrandr
            ];

          buildInputs = with pkgs; [
            combined
            netcoredbg
            omnisharp-roslyn
            openssl
          ];
        };
    });
}
