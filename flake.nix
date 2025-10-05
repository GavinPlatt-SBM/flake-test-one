{
  description = "Next.js Web App with Nix Flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nodeEnv = pkgs.buildInputs // [
        pkgs.nodejs
        pkgs.yarn
      ];
      nextjsApp = pkgs.stdenv.mkDerivation {
        name = "nextjs-app";
        src = ./.;
        buildInputs = nodeEnv;
        phases = [ "installPhase" "buildPhase" "installCheckPhase" ];

        installPhase = ''
          mkdir -p $out
          cp -r ./* $out/
          cd $out
          yarn install
        '';

        buildPhase = ''
          yarn build
        '';

        installCheckPhase = ''
          # Optionally, you can add a check to test the build
          echo "Build completed."
        '';
      };
    in
      {
        packages.${system}.nextjsApp = nextjsApp;
      });
}
