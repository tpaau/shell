pre-commit:
	just fmt

fmt:
	./scripts/fmt.sh

loc:
	cloc .

add:
	rm -r private_dot_config/
	chezmoi add ~/.config/quickshell/
	chezmoi add ~/.config/niri/
	chezmoi add ~/.config/fastfetch/
	just pre-commit
	git status
