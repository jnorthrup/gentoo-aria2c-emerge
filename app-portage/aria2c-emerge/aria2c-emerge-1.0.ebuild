# Copyright 2023 jnorthrup
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Portage utility script: aria2c fetch client for Gentoo"
HOMEPAGE="https://github.com/jnorthrup/gentoo-aria2c-emerge"
SRC_URI="https://raw.githubusercontent.com/jnorthrup/gentoo-aria2c-emerge/v${PV}/garia2c.bash -> garia2c.bash"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-mirrorselect +makeconf-modification"

DEPEND="
  net-misc/aria2
  mirrorselect? ( app-portage/mirrorselect )
"

src_unpack() {
  default
  # Make sure the script is executable
  chmod +x "${S}/garia2c.bash"
}

src_install() {
  exeinto "/usr/share/portage"
  doexe "garia2c.bash"

  # Add/update FETCHCOMMAND and RESUMECOMMAND in /etc/make.conf
  if use makeconf-modification; then
    # Create a date comment and explanation for the modification
    DATE=$(date +%Y-%m-%d)

    cat <<-EOF >> "${D}/etc/make.conf"
    # ${DATE} - ${PN} - ${DESCRIPTION}
	FETCHCOMMAND="/usr/share/portage/garia2c.bash \"\${DISTDIR}\" \"\${FILE}\" \"\${URI}\" \$GENTOO_MIRRORS"
	RESUMECOMMAND=\$FETCHCOMMAND
	EOF
  fi
}

pkg_preinst() {
  if use mirrorselect && has_version 'app-portage/mirrorselect'; then
    elog "The 'mirrorselect' USE flag is enabled, and 'app-portage/mirrorselect' package is installed."

    if [[ -t 0 ]]; then
      elog "Running 'mirrorselect -i' to optimize mirror selection for Gentoo package downloads."
      elog ""
      elog "Please wait a moment while 'mirrorselect -i' is running..."
      mirrorselect -i
    else
      ewarn "Running non-interactively. Performing a quick 'mirrorselect -s4' process instead."
      ewarn "To optimize mirror selection for Gentoo package downloads, please run 'mirrorselect -i' manually."
      ewarn ""
      ewarn "Please wait a moment while 'mirrorselect -s4' is running..."
      mirrorselect -s4
    fi
  elif use mirrorselect; then
    ewarn "The 'mirrorselect' USE flag is enabled, but 'app-portage/mirrorselect' package is not installed."
    ewarn "To optimize mirror selection for Gentoo package downloads, please install the 'app-portage/mirrorselect' package."
    ewarn ""
  fi

  if ! use makeconf-modification; then
    ewarn "The 'makeconf-modification' USE flag is currently disabled."
    ewarn "To modify /etc/make.conf manually, run the following command as root:"
    ewarn "cat <<-EOF >> /etc/make.conf"
    ewarn "FETCHCOMMAND=\"/usr/share/portage/garia2c.bash \\\"\${DISTDIR}\\\" \\\"\${FILE}\\\" \\\"\${URI}\\\" \\\$GENTOO_MIRRORS\""
    ewarn "RESUMECOMMAND=\\\$FETCHCOMMAND"
    ewarn "EOF"
  fi
}

pkg_pretend() {
  if use makeconf-modification; then
    ewarn "The 'makeconf-modification' USE flag is enabled."
    ewarn "This will modify the FETCHCOMMAND and RESUMECOMMAND variables in /etc/make.conf."
    ewarn "Please note that modifying these variables may cause unintended emerge interruptions."
    ewarn ""
    ewarn "To revert the changes, run the following command as root:"
    ewarn "grep '(FETCH|RESUME)COMMAND=' /usr/share/portage/config/make.globals >>/etc/make.conf"
  fi
}

pkg_postrm() {
  # Remove FETCHCOMMAND and RESUMECOMMAND from /etc/make.conf
  if use makeconf-modification && [[ -f "${ROOT}/etc/make.conf" ]]; then
  grep '(FETCH|RESUME)COMMAND=' /usr/share/portage/config/make.globals >>/etc/make.conf || die "Failed to revert FETCHCOMMAND and RESUMECOMMAND from make.conf"
  fi
}
