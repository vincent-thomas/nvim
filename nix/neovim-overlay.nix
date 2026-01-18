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

  all-plugins = [
    (mkNvimPlugin inputs.conform "conform")
    (mkNvimPlugin inputs.mini-nvim "mini")
    (mkNvimPlugin inputs.oil "oil")
    (mkNvimPlugin inputs.leap "leap")
    ((mkNvimPlugin inputs.catpuccin "catpuccin").overrideAttrs { doCheck = false; })
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.bash
      p.go
      p.javascript
      p.json
      p.lua
      p.markdown
      p.nix
      p.rust
      p.toml
      p.typescript
      p.yaml
      p.tcl
      p.sql
    ]))

    (inputs.fff-nvim.packages.${prev.stdenv.hostPlatform.system}.fff-nvim)
    (inputs.blink-cmp.packages.${prev.stdenv.hostPlatform.system}.blink-cmp)
  ];

  extraPackages = with pkgs; [
    # ripgrep

    # For nix
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
    # prettierd

    # Markdown
    marksman

    # # Go
    gopls
  ];
in
rec {
  vt-nvim = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  default = vt-nvim;

  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
