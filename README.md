# aria2c for gentoo

enablement:

cat >>/etc/make.conf <<EOF
FETCHCOMMAND="bash /usr/bin/garia2c \"\${DISTDIR}\" \"\${FILE}\" \"\${URI}\" $GENTOO_MIRRORS "
RESUMECOMMAND=$FETCHCOMMAND
GENTOO_MIRRORS="ftp://ftp.free.fr/mirrors/ftp.gentoo.org/ https://mirror.aarnet.edu.au/pub/gentoo/ http://ftp.fau.de/gentoo ftp://ftp-stud.hs-esslingen.de/pub/Mirrors/gentoo/ ftp://gentoo.bloodhost.ru/ http://gentoo.mirrors.tds.net/gentoo https://ftp.agdsn.de/gentoo http://ftp.ntua.gr/pub/linux/gentoo/"
EOF

