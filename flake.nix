{
  description = "DodOS repository template: pinned development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  # Rust comes from rust-overlay (the official binaries): nixpkgs is weeks
  # behind a release. Same pins as the kernel repository.
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  outputs =
    { nixpkgs, rust-overlay, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAll = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in
    {
      devShells = forAll (pkgs: {
        default = pkgs.mkShell {
          packages = [
            (rust-overlay.lib.mkRustBin { } pkgs).stable."1.100.0".default
            pkgs.lychee
          ];
        };
      });
    };
}
