{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    gen-luarc.inputs.nixpkgs.follows = "nixpkgs";

    mini-icons.url = "github:nvim-mini/mini.icons";
    mini-icons.flake = false;

    mini-hipatterns.url = "github:nvim-mini/mini.hipatterns";
    mini-hipatterns.flake = false;

    catpuccin.url = "github:catppuccin/nvim";
    catpuccin.flake = false;

    blink-cmp.url = "github:saghen/blink.cmp";
    blink-cmp.inputs.nixpkgs.follows = "nixpkgs";

    conform.url = "github:stevearc/conform.nvim";
    conform.flake = false;

    oil.url = "github:stevearc/oil.nvim";
    oil.flake = false;

    fzf-lua.url = "github:ibhagwan/fzf-lua";
    fzf-lua.flake = false;

    leap.url = "git+http://codeberg.org/andyg/leap.nvim";
    leap.flake = false;
  };

  outputs =
    inputs@{
      nixpkgs,
      gen-luarc,
      flake-utils,
      ...
    }:
    let
      neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
    in
    {
      overlays.default = neovim-overlay;
    }
    // flake-utils.lib.eachDefaultSystem (
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
          shellHook = "ln -fs ${pkgs.nvim-luarc-json} .luarc.json";
        };
      }
    );
}
