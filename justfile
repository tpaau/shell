pre-commit:
	./scripts/whitespace.sh

whitespace:
	./scripts/whitespace.sh

add:
	rm -r private_dot_config/
	chezmoi add ~/.config/quickshell/
	chezmoi add ~/.config/niri/
	chezmoi add ~/.config/fastfetch/
	chezmoi add ~/.config/nvim/
	just pre-commit
	git status
