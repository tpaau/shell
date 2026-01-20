pre-commit:
	just fmt
	just test

fmt:
	./scripts/fmt.sh

test:
	./scripts/static-tests.sh

add:
	rm -r private_dot_config/
	chezmoi add ~/.config/quickshell/
	chezmoi add ~/.config/niri/
	chezmoi add ~/.config/fastfetch/
	just pre-commit
	git status
