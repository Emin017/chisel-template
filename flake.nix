{
  description = "Chisel template flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  } @ inputs: let
    playground-overlay = import ./nix/overlay.nix {inherit self;};
  in
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            playground-overlay
          ];
        };
        deps = with pkgs; [
          git
          gnumake

          verilator
          ccache

          circt
          llvm
          (mill.override {jre = pkgs.jdk21;})

          gtkwave
        ];
      in {
        legacyPackages = pkgs;
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} {
          buildInputs = [deps];
          shellHook = ''
          '';
        };
      }
    )
    // {inherit inputs;};
}
