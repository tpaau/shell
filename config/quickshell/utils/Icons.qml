pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

    readonly property var osIcons: ({
		almalinux: "",
		alpine: "",
		arch: "",
		archcraft: "",
		arcolinux: "",
		artix: "",
		centos: "",
		debian: "",
		devuan: "",
		elementary: "",
		endeavouros: "",
		fedora: "",
		freebsd: "",
		garuda: "",
		gentoo: "",
		hyperbola: "",
		kali: "",
		linuxmint: "󰣭",
		mageia: "",
		openmandriva: "",
		manjaro: "",
		neon: "",
		nixos: "",
		opensuse: "",
		suse: "",
		sles: "",
		sles_sap: "",
		"opensuse-tumbleweed": "",
		parrot: "",
		pop: "",
		raspbian: "",
		rhel: "",
		rocky: "",
		slackware: "",
		solus: "",
		steamos: "",
		tails: "",
		trisquel: "",
		ubuntu: "",
		vanilla: "",
		void: "",
		zorin: "",
		secureblue: "󰌾"
	})

    property string osIcon: ""

	function getAppIcon(name: string): string {
		let entry = DesktopEntries.heuristicLookup(name)
		return entry ? Quickshell.iconPath(entry.icon) : ""
	}

	function pickIcon(value: real, icons: list<string>): string {
		return icons[Math.round((icons.length - 1) * value)]
	}

    FileView {
        path: "/etc/os-release"
        onLoaded: {
            const lines = text().split("\n");
            let osId = lines.find(l => l.startsWith("ID="))?.split("=")[1].replace(/"/g, "");
            if (root.osIcons.hasOwnProperty(osId))
                root.osIcon = root.osIcons[osId];
            else {
                const osIdLike = lines.find(l => l.startsWith("ID_LIKE="))?.split("=")[1].replace(/"/g, "");
                if (osIdLike)
                    for (const id of osIdLike.split(" "))
                        if (root.osIcons.hasOwnProperty(id))
                            return root.osIcon = root.osIcons[id];
            }
        }
    }
}
