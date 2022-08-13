{
  description = "my one package";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
        let pkgs = import nixpkgs {
          inherit system;
        }; in
        rec {
          packages = flake-utils.lib.flattenTree {
            one = pkgs.stdenv.mkDerivation {
              name = "one";
              src = self;
              buildInputs = [
                nixpkgs.legacyPackages.${system}.gcc
                nixpkgs.legacyPackages.${system}.clang
              ];
              configurePhase = ''
                make
              '';
              buildPhase = ''
                make
              '';
              installPhase = ''
                make
              '';
              program = "/bin/gcc";
              outputs = [ "out" ];
            };
          };
          defaultPackage = packages.one;
          apps = {
            one = flake-utils.lib.mkApp {
              drv = packages.one;
            };
          };
          defaultApp = apps.one;
        }
    );
  nixConfig.bash-prompt = "nix-dev: \\w\\$ ";
}
