# Copyright 2023 jnorthrup
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Script for parallel file download using aria2c (multi-platform)"
HOMEPAGE="https://github.com/jnorthrup/gentoo-aria2c-emerge"
SRC_URI="https://github.com/jnorthrup/gentoo-aria2c-emerge/archive/v1.0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/aria2"
RDEPEND="${DEPEND}"

src_install() {
    dobin garia2c

    # Enable garia2c in /etc/make.conf
    cat >> "${D}"/etc/make.conf <<-EOF
    FETCHCOMMAND="bash /usr/bin/garia2c \"\${DISTDIR}\" \"\${FILE}\" \"\${URI}\" \$GENTOO_MIRRORS"
    RESUMECOMMAND=\$FETCHCOMMAND
    EOF

    # Inform the user to run mirrorselect
    elog "Please run 'mirrorselect -Hs 4' to get at least 4 mirrors."
}
