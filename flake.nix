{
  description = "Neovim derivation";

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

    mini-files.url = "github:echasnovski/mini.files";
    mini-files.flake = false;

    mini-pick.url = "github:echasnovski/mini.pick";
    mini-pick.flake = false;

    mini-extra.url = "github:echasnovski/mini.extra";
    mini-extra.flake = false;

    fidget.url = "github:j-hui/fidget.nvim";
    fidget.flake = false;

    luasnip.url = "github:L3MON4D3/LuaSnip";
    luasnip.flake = false;
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
