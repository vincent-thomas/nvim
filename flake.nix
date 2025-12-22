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
    flake-utils.url = "github:numtide/flake-utils";

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    gen-luarc.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    # Plugins
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;

    mini-nvim.url = "github:echasnovski/mini.nvim";
    mini-nvim.flake = false;

    catpuccin.url = "github:catppuccin/nvim";
    catpuccin.flake = false;

    nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    nvim-cmp.flake = false;

    cmp-nvim-lsp.url = "github:hrsh7th/cmp-nvim-lsp";
    cmp-nvim-lsp.flake = false;

    conform.url = "github:stevearc/conform.nvim";
    conform.flake = false;

    gitsigns.url = "github:lewis6991/gitsigns.nvim";
    gitsigns.flake = false;

    fidget.url = "github:j-hui/fidget.nvim";
    fidget.flake = false;

    oil.url = "github:stevearc/oil.nvim";
    oil.flake = false;

    leap.url = "github:ggandor/leap.nvim";
    leap.flake = false;
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      gen-luarc,
      flake-utils,

      treefmt-nix,
      pre-commit-hooks,
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
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        formatter = treefmtEval.config.build.wrapper;

        checks = {
          formatting = treefmtEval.config.build.check self;

          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.treefmt = {
              enable = true;
              package = outputs.formatter.${system};
            };
          };
        };
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
