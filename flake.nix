{
  nixConfig = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://vt-nvim.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "vt-nvim.cachix.org-1:wphAxtBWVTY7PNTNwT1HzvQwsIBLl9RY/em+HeFjBgc="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    gen-luarc.inputs.nixpkgs.follows = "nixpkgs";

    fff-nvim.url = "github:dmtrKovalenko/fff.nvim";
    fff-nvim.inputs.nixpkgs.follows = "nixpkgs";
    fff-nvim.inputs.flake-utils.follows = "flake-utils";
    fff-nvim.inputs.rust-overlay.follows = "rust-overlay";

    # Plugins
    # nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    # nvim-lspconfig.flake = false;

    mini-nvim.url = "github:echasnovski/mini.nvim";
    mini-nvim.flake = false;

    catpuccin.url = "github:catppuccin/nvim";
    catpuccin.flake = false;

    blink-cmp.url = "github:saghen/blink.cmp";
    blink-cmp.inputs.nixpkgs.follows = "nixpkgs";

    conform.url = "github:stevearc/conform.nvim";
    conform.flake = false;

    # gitsigns.url = "github:lewis6991/gitsigns.nvim";
    # gitsigns.flake = false;
    #
    # fidget.url = "github:j-hui/fidget.nvim";
    # fidget.flake = false;

    oil.url = "github:stevearc/oil.nvim";
    oil.flake = false;

    leap.url = "git+ssh://git@codeberg.org/andyg/leap.nvim";
    leap.flake = false;
  };

  outputs =
    inputs@{
      self,
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

      inherit (self) outputs;
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
          shellHook = "ln -fs ${pkgs.nvim-luarc-json} .luarc.json";
          buildInputs = [ pkgs.vt-nvim ];
        };
      }
    )
    // {
      overlays.default = neovim-overlay;
    };
}
