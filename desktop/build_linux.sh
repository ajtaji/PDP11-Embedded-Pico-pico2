#!/bin/bash
# desktop/build_linux.sh - build the windowed PDP-11 (PDP11Desktop) and the console one
# (pdp11_cli) on Linux x64, with PureBasic 6.41's C back end. The same source as the
# Windows build (build_desktop.ps1, build_cli.ps1); everything the OS gives comes through
# the Neon Arcade Display Engine, found cloned beside this repository unless ENGINE=<folder/>
# names another (the trailing slash matters).
#
#   PUREBASIC_HOME=~/purebasic641/purebasic ./build_linux.sh
#
# Build from a Linux disk, not /mnt/c under WSL: there the compiler can include a file twice.
set -e
cd "$(dirname "$0")"
: "${PUREBASIC_HOME:?set PUREBASIC_HOME to the PureBasic folder (the one holding compilers/)}"
export PUREBASIC_HOME
PBC="$PUREBASIC_HOME/compilers/pbcompilerc"
extra=()
if [ -n "$ENGINE" ]; then extra=(--constant "GL_ENGINE_DIR\$=$ENGINE"); fi
"$PBC" PDP11Desktop.pb -t -z -o PDP11Desktop "${extra[@]}" | tail -n 4
"$PBC" pdp11_cli.pb -cl -z -o pdp11_cli "${extra[@]}" | tail -n 3
