pre-commit:
	just check
	just find-unused
	# just fmt

fmt:
	./scripts/fmt.sh

check-fmt:
	./scripts/fmt.sh --check

check:
	./scripts/checks/check-lock.sh

find-unused:
	./scripts/checks/find-unused.sh --no-fail

loc:
	cloc . --fullpath --not-match-d=private_dot_config/quickshell/cache/ --exclude-lang Markdown

add:
	rm -r private_dot_config/
	chezmoi add ~/.config/quickshell/
	chezmoi add ~/.config/niri/
	chezmoi add ~/.config/fastfetch/
	just pre-commit
	git status
