{
  projectRootFile = "flake.nix";

  settings.global.excludes = [
    ".*"
    "result"
    "LICENSE"
  ];

  programs.stylua.enable = true;

  # Nix
  programs.nixfmt.enable = true;
  # MD
  programs.mdformat.enable = true;

  programs.toml-sort.enable = true;
}
