pragma Singleton

import Quickshell

// Security-related settings that should be require root privileges to access if lockdown is enabled
Singleton {
	id: root

	enum AuthenticationMethod {
		Password,
		PasswordAndFingerprint,
		FingerprintOrPasswordS
	}
}
