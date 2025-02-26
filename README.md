<table align="center">
<tr><td align="center" width="9999">

# VTs nvim.nix

<div align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</div>
<div align="center">
  <img src="https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=fff&style=for-the-badge">
  <img src="https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=fff&style=for-the-badge">
</div>

</td></tr>
</table>

## :bicyclist: Try

If you have Nix installed (with [flakes](https://wiki.nixos.org/wiki/Flakes) enabled),
you can test drive this by running:

```console
nix run "github:vincent-thomas/nvim"
```

## :robot: Design

Directory structure:

```sh
── flake.nix
── nvim # Neovim configs (lua), equivalent to ~/.config/nvim
── nix # Nix configs
```

Directory structure:

```sh
── nvim
  ├── init.lua # Always sourced
  ├── lua
  │  └── vt
  │     └── <lib>.lua
  ├── plugin # Automatically sourced at startup
  │  └── <plugin-config>.lua # Plugin configurations
  └── after # Empty in this template
     ├── plugin # Sourced at the very end of startup (rarely needed)
     └── ftplugin # Sourced when opening a filetype, after sourcing ftplugin scripts
```

### :open_file_folder: Nix

You can declare Neovim derivations in `nix/neovim-overlay.nix`.

There are two ways to add plugins:

- The traditional way, using `nixpkgs` as the source.
- By adding plugins as flake inputs (if you like living on the bleeding-edge).
  Plugins added as flake inputs must be built in `nix/plugin-overlay.nix`.

Directory structure:

```sh
── flake.nix
── nix
  ├── mkNeovim.nix # Function for creating the Neovim derivation
  └── neovim-overlay.nix # Overlay that adds Neovim derivation
```

### :mag: Initialization order

This derivation creates an `init.lua` as follows:

1. Add `nvim/lua` to the `runtimepath`.
1. Add the content of `nvim/init.lua`.
1. Add `nvim/*` to the `runtimepath`.
1. Add `nvim/after` to the `runtimepath`.

This means that modules in `nvim/lua` can be `require`d in `init.lua` and `nvim/*/*.lua`.

Modules in `nvim/plugin/` are sourced automatically, as if they were plugins.
Because they are added to the runtime path at the end of the resulting `init.lua`,
Neovim sources them _after_ loading plugins.
