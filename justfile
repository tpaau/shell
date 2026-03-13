fmt:
	./scripts/fmt.sh

check:
	./scripts/checks/check-lock.sh
	cargo test --workspace
	cargo deny check

loc:
	cloc . --fullpath

clean:
	cargo clean --workspace

build-helpers-dev:
	cargo build --workspace

build-helpers-relase:
	cargo build --workspace --release

install-helpers-dev:
	just build-helpers-dev
	rm -rf ~/.config/quickshell/bin/
	mkdir -p ~/.config/quickshell/bin/
	cp target/debug/notif-helper ~/.config/quickshell/bin

install-helpers-release:
	just build-helpers-relase
	rm -rf ~/.config/quickshell/bin/
	mkdir -p ~/.config/quickshell/bin/
	cp target/debug/notif-helper ~/.config/quickshell/bin

add:
	rm -rf config/
	mkdir -p config/niri/
	cp -r ~/.config/niri/* config/niri
	mkdir -p config/quickshell/
	cp -r ~/.config/quickshell/* config/quickshell
	just check
	git status
