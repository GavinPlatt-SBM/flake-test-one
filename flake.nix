{
  description = "Next.js Web App with Nix Flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      nextjsApp = pkgs.stdenv.mkDerivation {
        name = "nextjs-app";
        src = ./.;

        nativeBuildInputs = [ pkgs.nodejs pkgs.yarn ];

        installPhase = ''
          mkdir -p $out
          cp -r . $out
          cd $out
          yarn install
        '';

        buildPhase = ''
          yarn build
        '';
      };
    in {
      packages.${system}.nextjsApp = nextjsApp;
      packages.${system}.default = nextjsApp;
    });
}
