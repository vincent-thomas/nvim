{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final // final.pkgs;

  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.rev;
    };

  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = [
    (mkNvimPlugin inputs.conform "conform")
    (mkNvimPlugin inputs.mini-icons "mini.icons")
    (mkNvimPlugin inputs.oil "oil")
    (mkNvimPlugin inputs.leap "leap")
    ((mkNvimPlugin inputs.fzf-lua "fzf-lua").overrideAttrs { doCheck = false; })
    ((mkNvimPlugin inputs.catpuccin "catpuccin").overrideAttrs { doCheck = false; })
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.bash
      p.go
      p.lua
      p.markdown
      p.nix
      p.rust
      p.toml
      p.javascript
      p.typescript
      p.json
      p.yaml
      p.tcl
      p.sql
    ]))

    (inputs.blink-cmp.packages.${prev.stdenv.hostPlatform.system}.blink-cmp)
  ];

  eagle-lsp = pkgs.buildNpmPackage {
    pname = "eagle-lsp";
    version = "1.0.1";

    src = inputs.eagle-lsp;

    npmDepsHash = "sha256-MkeCOVx7oy/RAYkvHfN80M8/FTmavinapPeMEh9I6y4=";

    dontNpmBuild = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/eagle-lsp
      cp -r server.js eagle-data.js eagle-parser.js data node_modules $out/lib/eagle-lsp/
      mkdir -p $out/bin
      makeWrapper ${pkgs.nodejs_22}/bin/node $out/bin/eagle-lsp \
        --add-flags "$out/lib/eagle-lsp/server.js" \
        --add-flags "--stdio"
      runHook postInstall
    '';
  };

  extraPackages = with pkgs; [
    fzf
    nixd
    nixfmt
    bash-language-server
    lua-language-server
    stylua
    rustfmt
    typescript-language-server
    marksman
    gopls
    eagle-lsp
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
