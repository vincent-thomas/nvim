{
  description = "Neovim derivation";
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

    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;

    conform.url = "github:stevearc/conform.nvim";
    conform.flake = false;

    lualine.url = "github:nvim-lualine/lualine.nvim";
    lualine.flake = false;

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    gen-luarc.inputs.nixpkgs.follows = "nixpkgs";

    oil.url = "github:stevearc/oil.nvim";
    oil.flake = false;

    mini-pick.url = "github:echasnovski/mini.pick";
    mini-pick.flake = false;

    mini-extra.url = "github:echasnovski/mini.extra";
    mini-extra.flake = false;

    fidget.url = "github:j-hui/fidget.nvim";
    fidget.flake = false;

    luasnip.url = "github:L3MON4D3/LuaSnip";
    luasnip.flake = false;

    markdown.url = "github:MeanderingProgrammer/render-markdown.nvim";
    markdown.flake = false;

    copilot-lua.url = "github:zbirenbaum/copilot.lua";
    copilot-lua.flake = false;

    copilot-cmp.url = "github:zbirenbaum/copilot-cmp";
    copilot-cmp.flake = false;
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

          buildInputs = [ pkgs.vt-nvim ];
        };
      }
    )
    // {
      overlays.default = neovim-overlay;
    };
}
