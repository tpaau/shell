pre-commit:
	./scripts/whitespace.sh

whitespace:
	./scripts/whitespace.sh

loc:
	echo "$(find . -type f -name "*.qml" -exec cat {} \; | wc -l) lines of code"

add:
	rm -r private_dot_config/
	chezmoi add ~/.config/quickshell/
	chezmoi add ~/.config/niri/
	chezmoi add ~/.config/fastfetch/
	chezmoi add ~/.config/nvim/
	just pre-commit
