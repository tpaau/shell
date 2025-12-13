pre-commit:
	./scripts/whitespace.sh

whitespace:
	./scripts/whitespace.sh

loc:
	echo "$(find . -type f -name "*.qml" -exec cat {} \; | wc -l) lines of code"
