/// Simple logger for the desktop shell.
///
/// Takes the log level from the `RUST_LOG` environment variable.
use env_logger::Builder;

pub fn init() {
    Builder::from_env("RUST_LOG").init();
}
