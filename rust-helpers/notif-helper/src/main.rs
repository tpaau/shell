use std::process::exit;

use clap::Parser;
use log::{debug, error, trace, warn};

#[derive(Parser, Debug)]
struct Args {
    #[arg(long, short)]
    pub summary: String,

    #[arg(long, short)]
    pub body: String,

    #[arg(long, short)]
    pub app: String,

    #[arg(long, short)]
    pub urgency: String,

    #[arg()]
    pub actions: Vec<String>,
}

#[derive(Debug)]
enum NotificationUrgency {
    Low,
    Normal,
    Critical,
}

impl TryFrom<&str> for NotificationUrgency {
    type Error = String;
    fn try_from(value: &str) -> Result<Self, Self::Error> {
        match value {
            "low" => Ok(NotificationUrgency::Low),
            "normal" => Ok(NotificationUrgency::Normal),
            "critical" => Ok(NotificationUrgency::Critical),
            _ => Err(format!("No matching urgency level for \"{value}\"!")),
        }
    }
}

impl Into<notify_rust::Urgency> for NotificationUrgency {
    fn into(self) -> notify_rust::Urgency {
        match self {
            Self::Low => notify_rust::Urgency::Low,
            Self::Normal => notify_rust::Urgency::Normal,
            Self::Critical => notify_rust::Urgency::Critical,
        }
    }
}

#[derive(Debug)]
struct NotificationAction {
    pub name: String,
    pub shell: String,
}

impl From<(String, String)> for NotificationAction {
    fn from(value: (String, String)) -> Self {
        Self {
            name: value.0,
            shell: value.1,
        }
    }
}

#[derive(Debug)]
struct Notification {
    pub summary: String,
    pub body: String,
    pub app: String,
    pub urgency: NotificationUrgency,
    pub actions: Vec<NotificationAction>,
}

impl TryFrom<Args> for Notification {
    type Error = String;
    fn try_from(value: Args) -> Result<Self, Self::Error> {
        if !value.actions.len().is_multiple_of(2) {
            return Err(String::from(
                "You must provide notification actions in format [NAME] [SHELL CODE], but the number of elements was not even!",
            ));
        }
        let urgency = NotificationUrgency::try_from(&value.urgency[..])?;

        let mut i = 0;
        let mut actions: Vec<NotificationAction> = vec![];
        while i < value.actions.len() / 2 {
            actions.push(NotificationAction::from((
                value.actions[i * 2].clone(),
                value.actions[i * 2 + 1].clone(),
            )));
            i += 1;
        }

        Ok(Notification {
            summary: value.summary,
            body: value.body,
            app: value.app,
            urgency,
            actions,
        })
    }
}

fn send_notif(notif: Notification) -> Result<(), notify_rust::error::Error> {
    trace!("{notif:?}");

    let mut notification = notify_rust::Notification::new();
    notification
        .summary(&notif.summary)
        .body(&notif.body)
        .appname(&notif.app)
        .urgency(notif.urgency.into());

    for (i, action) in notif.actions.iter().enumerate() {
        notification.action(&i.to_string(), &action.name);
    }

    let handle = match notification.show() {
        Ok(a) => a,
        Err(e) => {
            error!("Could not show notification: ${e}");
            return Err(e);
        }
    };

    handle.wait_for_action(|action| {
        trace!("Action picked in the notification: {action}");
        if action == "__closed" {
            debug!("Notification closed without reponse");
            return;
        }
        let id = match action.parse::<usize>() {
            Ok(id) => id,
            Err(e) => {
                warn!("Could not parse notification action index: {e}");
                return;
            }
        };
        let action = &notif.actions[id];

        trace!("Found corresponding action: {action:?}");

        match cmd::run_shell_command(&action.shell) {
            Ok(status) => {
                if status.exit_code == 0 {
                    debug!("Command executed succesfully");
                } else {
                    warn!("Command exited with code {}", status.exit_code);
                }
            }
            Err(e) => error!("Could not execute the command: {e}"),
        }
    });

    Ok(())
}

fn main() {
    logger::init();
    match Notification::try_from(Args::parse()) {
        Ok(notif) => match send_notif(notif) {
            Ok(_) => exit(0),
            Err(_) => exit(2),
        },
        Err(e) => {
            error!("Could not parse args: {e}");
            exit(1);
        }
    }
}
