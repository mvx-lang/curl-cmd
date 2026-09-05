#!/bin/sh
# build-pkg.sh — stage the curl-cmd release account into $1.
# Copyright (C) 2026 Gordon Heydon.  GPL-2.0-only (see LICENSE).
#
#   sh build-pkg.sh <stagedir>
#
# curl-cmd is BASIC and shell only -- HTTPGET/HTTPGETFILE shell out to the OS
# `curl` -- so there is NOTHING TO COMPILE and nothing platform-specific in the
# tree.  The same staged account is what udt, uv and jbase each install; the
# per-platform part is the cataloging, which MVPKG does on the target.
#
# That is why the artifacts are `<sys>-any-any-le` and are built on a plain
# hosted runner: os/arch-locking a package with no native code would pin it to
# the machine that happened to package it, and asking for a licensed container
# to copy six files would make releases depend on a self-hosted runner for no
# gain.  The endian stays `le` rather than `any` because that is the axis a
# compiled BASIC object would care about if this package ever grows one.
set -e
STAGE="${1:?usage: build-pkg.sh <stagedir>}"
HERE="$(cd "$(dirname "$0")" && pwd)"
ACCT="$STAGE/curl-cmd"

mkdir -p "$ACCT/BP"
cp "$HERE"/BP/HTTPGET "$HERE"/BP/HTTPGETFILE "$ACCT/BP/"
cp "$HERE"/PKG "$HERE"/mvpkg.json "$HERE"/LICENSE "$HERE"/README.md "$ACCT/"

# EVERY STAGED SOURCE GETS A TRAILING NEWLINE.  UniVerse's compiler rejects a
# source whose last line is unterminated -- "End of File unexpected, Was
# expecting: ';', End of Line" -- and the repo's items do not all have one, so this
# is not cosmetic: without it the uv artifact cannot be compiled on the target at
# all, and the package installs as a directory of sources that never become
# programs.  Appending only when it is missing keeps re-staging idempotent.
for f in "$ACCT"/BP/*; do
   [ -f "$f" ] || continue
   [ -n "$(tail -c 1 "$f")" ] && printf '\n' >> "$f"
done

echo "build-pkg: staged curl-cmd as $ACCT/"
