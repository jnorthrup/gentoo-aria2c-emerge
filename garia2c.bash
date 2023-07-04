#!/bin/bash

DISTDIR="$1"
#if empty show help and exit
if [ -z "$DISTDIR" ]; then
cat <<-EOF
Install make.conf mod to use aria2c for distfiles:
$0 install
Normal Usage: $0 DISTDIR FILE URI [MIRRORS...]
EOF
exit 1
fi

#if DISTDIR is "install" then run the make.conf mod
if [ "$DISTDIR" = "install" ]; then

cat <<-EOF >>/etc/make.conf
FETCHCOMMAND="/usr/share/portage/garia2c.bash \\\${DISTDIR} \\\${FILE} \\\${URI} \\\$GENTOO_MIRRORS"
RESUMECOMMAND=\$FETCHCOMMAND
EOF
  exit 1
fi

set -x

FILE="$2"
# Determine an idempotent temp file
: tempdir is ${TMPDIR:=/tmp}

FILE_HASH=$(echo -n "$FILE" | md5sum | cut -d ' ' -f 1)
TMPFILE="$TMPDIR/$FILE_HASH"

# If the temp file does not exist, create it
[[ ! -f "$TMPFILE" ]] && {
  URI="$3"
  shift 3
  # the rest of the arguments are the mirrors

  : the mirrors: $@
  MIRRORS=($@)

  pushd "$DISTDIR"

  # start building the aria2c command
  CMD="aria2c -c -j 15 -s 15 -x 15 --remote-time --http-accept-gzip --uri-selector=adaptive  -d $DISTDIR -o $FILE"
  CMD=($CMD)

  # find the index of the mirror that is being used as the prefix of the URI
  key_index=0
  for index in "${!MIRRORS[@]}"; do
    [[ "$URI" == "${MIRRORS[$index]}"* ]] && key_index=$index && break
  done

  # for each mirror
  for index in "${!MIRRORS[@]}"; do
    # if the current index is not equal to the key_index
    [[ $index -ne $key_index ]] && {
      # replace the key mirror in the URI with the current mirror
      MIRROR_URI=$(echo "$URI" | sed "s#${MIRRORS[$key_index]}#${MIRRORS[$index]}#g")
      # add the mirror URI to the command
      CMD+=("$MIRROR_URI")
    }
  done

  # Store the aria2c command in the temp file
  echo "${CMD[@]}" >"$TMPFILE"
}

# Execute the aria2c command
. "$TMPFILE" && rm "$TMPFILE" || {
  echo "Failed to download $FILE into $DISTDIR from $URI using aria2c in $TMPFILE" with exit code ${errcode:=$?} >&2
  exit $errcode
}
