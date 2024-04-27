{
  description = "Direnv environment for rust";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.fenix = {
    url = "github:nix-community/fenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, flake-utils, fenix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fenix.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            (pkgs.fenix.stable.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-analyzer"
            ])
            pkgs.bacon
            pkgs.pkg-config
            pkgs.openssl
          ];
          shellHook = ''
            export PKG_CONFIG_PATH=${
              pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
                pkgs.glib
                pkgs.gtk3
                pkgs.pango
                pkgs.gdk-pixbuf
                pkgs.cairo
                pkgs.at-spi2-atk
                pkgs.harfbuzz
                pkgs.zlib
                pkgs.gtk-layer-shell
              ]
            }
          '';
        };
      });
}