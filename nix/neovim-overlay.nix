# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions

    fzf-lua

    gitsigns-nvim
    conform-nvim
    fidget-nvim
    nvim-lspconfig

    catppuccin-nvim
    oil-nvim

    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    # nvim-treesitter-context # nvim-treesitter-context

    # nvim-surround # https://github.com/kylechui/nvim-surround/
    # nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    # nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    plenary-nvim
    nvim-web-devicons
  ];

  extraPackages = with pkgs; [
    statix
    nixd
    nixfmt-rfc-style

    lua-language-server

    rustfmt
    rust-analyzer
  ];
in {
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
