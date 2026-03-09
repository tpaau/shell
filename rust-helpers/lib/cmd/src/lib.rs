use std::{io, process::{Command, Stdio}};

pub struct ExitData {
    pub stdout: String,
    pub stderr: String,
    pub exit_code: i32,
}

pub fn run_shell_command(cmd: &str) -> io::Result<ExitData> {
    let output = Command::new("sh")
        .args(["-c", cmd])
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .output()?;

    let stdout = String::from_utf8_lossy(&output.stdout).into_owned();
    let stderr = String::from_utf8_lossy(&output.stderr).into_owned();
    let exit_code = output.status.code().unwrap_or(1);

    Ok(ExitData { stdout, stderr, exit_code })
}
