build:
	nix run .#luarc
	nix build .

run:
	nix run .#luarc
	nix build .
	exec ./result/bin/nvim
