# Copyright 2023 jnorthrup
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Portage utility script: aria2c fetch client for Gentoo"
HOMEPAGE="https://github.com/jnorthrup/gentoo-aria2c-emerge"
EGIT_REPO_URI="https://github.com/jnorthrup/gentoo-aria2c-emerge.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND="
net-misc/aria2
"

src_install() {
    exeinto "/usr/share/portage"
    doexe "garia2c.bash"
}

pkg_preinst() {
     :
}

pkg_pretend() {
    :
}

pkg_postrm() {
    :
}
