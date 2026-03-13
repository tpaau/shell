fmt:
	# ./scripts/fmt.sh
	cargo fmt --all

check:
	./scripts/checks/check-lock.sh
	cargo test --workspace
	cargo fmt --all --check
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
	just fmt
	just check
	git status
