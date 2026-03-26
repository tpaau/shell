fmt:
	# ./scripts/fmt.sh
	cargo fmt --all

check:
	./scripts/checks/check-lock.sh
	cargo test --workspace
	cargo fmt --all --check
	cargo deny check

loc:
	cloc . --fullpath --not-match-d=target --fullpath --not-match-d=build/

clean:
	cargo clean --workspace
	rm -rf build/

rm-shell-dirs:
	rm -rf ~/.cache/tpaau-shell/
	rm -rf ~/.config/tpaau-shell/
	rm -rf ~/.local/share/tpaau-shell/

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
	mkdir -p build/dev/quickshell/bin/
	cp -r config/quickshell/ build/dev/
	just build-helpers-dev
	cp target/debug/notif-helper config/quickshell/bin
	build/dev/quickshell/scripts/qs-safe-wrapper.sh

add:
	rm -rf config/
	mkdir -p config/quickshell/
	cp -r ~/.config/quickshell/* config/quickshell
	just fmt
	just check
	git status
