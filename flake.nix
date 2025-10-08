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
    pname = "nextjs-app";
    version = "0.1.0";
    src = ./.;
    buildInputs = [ pkgs.nodejs ];

    phases = [ "installPhase" "buildPhase" ];

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      cd $out
      npm install --production --legacy-peer-deps
    '';

    buildPhase = ''
      npm run build
    '';
  };

    in {
      packages.nextjsApp = nextjsApp;
      packages.default = nextjsApp;
    });
}

