{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-buffer
    cmp-path
    cmp-nvim-lua

    fzf-lua

    gitsigns-nvim
    conform-nvim
    fidget-nvim
    nvim-lspconfig

    catppuccin-nvim
    oil-nvim

    lualine-nvim

    plenary-nvim
    nvim-web-devicons
  ];

  extraPackages = with pkgs; [
    # For nix
    statix
    nixd
    nixfmt-rfc-style

    # For lua
    lua-language-server
    stylua

    # For rust
    rustfmt
    rust-analyzer

    # Ts/js
    typescript-language-server
    prettierd
  ];
in
{
  vt-nvim = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
