{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    # Add bleeding-edge plugins here.
    # They can be updated with `nix flake update` (make sure to commit the generated flake.lock)
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      gen-luarc,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
            neovim-overlay
            # The generated file can be symlinked in the devShell's shellHook.
            gen-luarc.overlays.default
          ];
        };
      in
      {
        packages = rec {
          default = nvim;
          nvim = pkgs.vt-nvim;
        };
      }
    )
    // {
      overlays.default = neovim-overlay;
    };
}
