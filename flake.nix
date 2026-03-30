{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    gen-luarc.inputs.nixpkgs.follows = "nixpkgs";

    fzf-lua.url = "github:ibhagwan/fzf-lua";
    fzf-lua.flake = false;

    leap.url = "git+http://codeberg.org/andyg/leap.nvim";
    leap.flake = false;

    oil.url = "github:stevearc/oil.nvim";
    oil.flake = false;

    conform.url = "github:stevearc/conform.nvim";
    conform.flake = false;

    blink-cmp.url = "github:saghen/blink.cmp";
    blink-cmp.inputs.nixpkgs.follows = "nixpkgs";

    mini-icons.url = "github:nvim-mini/mini.icons";
    mini-icons.flake = false;

    catpuccin.url = "github:catppuccin/nvim";
    catpuccin.flake = false;

    eagle-lsp.url = "github:mistachkin/eagle-lsp";
    eagle-lsp.flake = false;
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      gen-luarc,
      ...
    }:
    let
      neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
      pkgsForSystem =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            neovim-overlay
            gen-luarc.overlays.default
          ];
        };
    in
    {
      overlays.default = neovim-overlay;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = pkgsForSystem system;
      in
      {
        packages = rec {
          default = nvim;
          nvim = pkgs.vt-nvim;
        };

        apps = {
          luarc =
            let
              luarc-script = pkgs.writeShellScriptBin "luarc-devsetup" ''
                ln -fs ${pkgs.nvim-luarc-json} .luarc.json
              '';
            in
            {
              type = "app";
              program = "${luarc-script}/bin/luarc-devsetup";
            };
        };

        devShell = pkgs.mkShell {
          shellHook = "ln -fs ${pkgs.nvim-luarc-json} .luarc.json";
        };
      }
    );
}
