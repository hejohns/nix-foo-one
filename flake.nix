{
  description = "my one package";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
        let pkgs = import nixpkgs {
          inherit system; # why does import nixpkgs eval to a function expecting a set w/ attribute system?
        }; in
        rec {
          packages = flake-utils.lib.flattenTree {
            one = pkgs.stdenv.mkDerivation rec {
              # the attributes will all be set env variables
              # (see src)
              #name = "one"; # required by stdenv. But it's preferred to set pname and version instead
              pname = "one";
              version = "0.0";
              src = self; # literally sets $src to tmp dir that is a clone of this dir (check w/ nix develop)
              strictDeps = true;
              buildInputs = [
                nixpkgs.legacyPackages.${system}.gcc
                nixpkgs.legacyPackages.${system}.clang
                nixpkgs.legacyPackages.${system}.SDL
              ];
              postUnpack = ''
                echo 'postUnpack ed!'
                '';
              postPatch = ''
                echo 'postPatch ed!'
                '';
              configurePhase = ''
                pwd
                ls
                env
                echo HERE
                gcc -v
                echo THERE
                '';
              buildPhase = ''
                make
                '';
              postBuild = ''
                echo "this doesn't run twice right?"
                '';
              doCheck = true;
              checkPhase = ''
                echo 'checking...?'
                stat $name
                '';
              installPhase = ''
                mkdir -p $out/bin
                cp $name $out/bin
                '';
              postInstall = ''
                ls $out
                '';
              seperateDebugInfo = true;
              program = "/bin/gcc";
              # TODO:
              outputs = [ "out" ];
            };
          };
          defaultPackage = packages.one;
          apps = {
            one = flake-utils.lib.mkApp {
              drv = packages.one;
              name = packages.one.name;
            };
          };
          defaultApp = apps.one;
        }
    );
  nixConfig.bash-prompt = "nix-dev: \\w\\$ ";
}
