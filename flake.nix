{
  description = "Exploring WebAssembly for versatile plugin system through the example of a text editor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
  };
  outputs = {self, nixpkgs, devshell, utils, ...}@inputs:
    utils.lib.eachSystem ["x86_64-linux"] (system:
      let
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlays.default ];
        };
        typstPackagesCache = pkgs.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = inputs.typst-packages;
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out/typst/packages"
            cp --dereference --no-preserve=mode --recursive --reflink=auto \
              --target-directory="$out/typst/packages" -- "$src"/packages/*
          '';
        };
      in
      {
        packages.main = inputs.typix.lib.${system}.buildTypstProject {
          name = "main.pdf";
          src = ./work/main.typ;
          XDG_CACHE_HOME = typstPackagesCache;
        };

        devShells.default = (pkgs.devshell.mkShell {
          name = "work";
          packages = with pkgs; [
            typst
            tinymist
            lato
          ];
          
          env = [
            {
              name = "TYPST_FONT_PATHS";
              value = "${pkgs.lato}/share/fonts/lato";
            }
          ];
          
          commands = [
            {
              name = "watch";
              command = ''
                typst watch --root "$PRJ_ROOT/work" "$PRJ_ROOT/work/main.typ"
              '';
              help = "watch the main typst project and recompile on changes";
            }
            {
              name = "watch-pres";
              command = ''
                typst watch --root "$PRJ_ROOT/presentation" "$PRJ_ROOT/presentation/main.typ"
              '';
              help = "watch the presentation typst project and recompile on changes";
            }
          ];
        });
      });
  # });
}
