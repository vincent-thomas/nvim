{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    fzf-lua.url = "github:ibhagwan/fzf-lua";
    fzf-lua.flake = false;

    oil.url = "github:stevearc/oil.nvim";
    oil.flake = false;

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    gen-luarc.inputs.nixpkgs.follows = "nixpkgs";

    # Add bleeding-edge plugins here.
    # They can be updated with `nix flake update` (make sure to commit the generated flake.lock)
  };

  outputs =
    inputs@{
      nixpkgs,
      gen-luarc,
      flake-utils,
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
            gen-luarc.overlays.default
          ];
        };
      in
      {
        packages = rec {
          default = nvim;
          nvim = pkgs.vt-nvim;
        };

        devShell = pkgs.mkShell {
          shellHook =
            let
              luarc = pkgs.nvim-luarc-json;
            in
            ''
              ln -fs ${luarc} .luarc.json
            '';
        };
      }
    )
    // {
      overlays.default = neovim-overlay;
    };
}
