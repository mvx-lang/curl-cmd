# curl-cmd

The **command** HTTP transport for MultiValue on Rocket UniData: `HTTPGET` and
`HTTPGETFILE` implemented by shelling out to the OS **`curl`** binary.

It declares `provides: ["curl"]`, so a package (or MVPKG itself) that depends on
the virtual name **`curl`** is satisfied by installing curl-cmd — with **no C
compiler and no libcurl** required, only the `curl` command (which MVPKG already
requires as a prerequisite). This makes it the default, works-everywhere HTTP
transport.

For **in-process** HTTP (libcurl via CallC — faster, no per-request fork),
install [`mvx-lang/curl`](https://github.com/mvx-lang/curl) instead: it provides
the same `HTTPGET`/`HTTPGETFILE` verbs (overriding curl-cmd's when installed) but
needs `gcc` + the OS `libcurl` at install time.

Pure BASIC — installs by cataloging `BP/HTTPGET` and `BP/HTTPGETFILE`; the
registry serves a single portable source artifact. GPL-2.0-only.
