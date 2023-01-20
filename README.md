# aria2c for gentoo

enablement:

using your mouse, paste this


```
FETCHCOMMAND="bash /usr/bin/garia2c \"\${DISTDIR}\" \"\${FILE}\" \"\${URI}\" $GENTOO_MIRRORS "
RESUMECOMMAND=$FETCHCOMMAND
GENTOO_MIRRORS="ftp://ftp.free.fr/mirrors/ftp.gentoo.org/ https://mirror.aarnet.edu.au/pub/gentoo/ http://ftp.fau.de/gentoo ftp://ftp-stud.hs-esslingen.de/pub/Mirrors/gentoo/ ftp://gentoo.bloodhost.ru/ http://gentoo.mirrors.tds.net/gentoo https://ftp.agdsn.de/gentoo http://ftp.ntua.gr/pub/linux/gentoo/"
```

using 

`cat >>/etc/make.conf `

add garia2c to /usr/bin or submit a PR for a better more-gentoo installation.

run `mirrorselect -Hs 4` to get at least 4 mirrors

cleanup PR's welcome!  I'm surprised it works, but it works especially well for emerge-webrsync.  
