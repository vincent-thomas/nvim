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
      version = src.rev;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = with pkgs.vimPlugins; [
    (mkNvimPlugin inputs.nvim-lspconfig "nvim-lspconfig")
    ((mkNvimPlugin inputs.blink-cmp "blink.cmp").overrideAttrs {
      doCheck = false;
    })
    (mkNvimPlugin inputs.conform "conform")
    (mkNvimPlugin inputs.oil "oil")
    (mkNvimPlugin inputs.mini-nvim "mini")
    (mkNvimPlugin inputs.fidget "fidget")
    (mkNvimPlugin inputs.gitsigns "gitsigns")
    nvim-treesitter.withAllGrammars
    ((mkNvimPlugin inputs.plenary "plenary").overrideAttrs {
      doCheck = false;
    })
  ];

  extraPackages = with pkgs; [
    ripgrep

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

    # Astro
    astro-language-server

    # Markdown
    marksman

    # Emmet
    emmet-ls

    terraform-ls
    tflint

    # Go
    gopls

    # C++
    clang-tools # includes clangd and clang-format

    # sql
    sqlfluff
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
