fmt:
	# ./scripts/fmt.sh
	cargo fmt --all

check:
	./scripts/checks/check-lock.sh
	cargo test --workspace
	cargo fmt --all --check
	cargo deny check

loc:
	cloc . --fullpath --fullpath --not-match-d=target/debug --not-match-d=target/release

clean:
	cargo clean --workspace
	rm -rf build/

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
	cp target/release/notif-helper ~/.config/quickshell/bin

run-dev:
	mkdir -p build/dev/.config/
	cp -r config/quickshell/ build/dev/.config/
	mkdir -p build/dev/.config/quickshell/bin/
	just build-helpers-dev
	cp target/debug/notif-helper build/dev/.config/quickshell/bin
	HOME="$(pwd)/build/dev" build/dev/.config/quickshell/scripts/qs-safe-wrapper.sh

add:
	rm -rf config/
	mkdir -p config/niri/
	cp -r ~/.config/niri/* config/niri
	mkdir -p config/quickshell/
	cp -r ~/.config/quickshell/* config/quickshell
	just fmt
	just check
	git status
