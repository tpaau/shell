pre-commit:
	just check
	just fmt

fmt:
	./scripts/checks/fmt.sh

check:
	./scripts/checks/check-lock.sh

loc:
	cloc . --fullpath --not-match-d=private_dot_config/quickshell/cache/ --exclude-lang Markdown

add:
	rm -r private_dot_config/
	chezmoi add ~/.config/quickshell/
	chezmoi add ~/.config/niri/
	chezmoi add ~/.config/fastfetch/
	just pre-commit
	git status
