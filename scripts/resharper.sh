#!/bin/sh

set -e -u

D=$(dirname "$(readlink "$0")")
exec "$D/runtime.sh" "$D/inspectcode.exe" "$@"
