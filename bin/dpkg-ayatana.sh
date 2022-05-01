#!/usr/bin/env bash

# Copyright (c) 2022, Mayeku Khisa.
#
# This file is part of Dpkg-ayatana.
#
# You may not use this file except in compliance with the terms of the MIT
# License as appearing in the LICENSE file included in the root of this source
# tree.
#
# THIS FILE IS PROVIDED BY THE COPYRIGHT HOLDER ON AN "AS IS" BASIS, WITHOUT
# WARRANTY OF ANY KIND, INCLUDING, BUT NOT LIMITED TO, THE WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

set -e

# Resolve symlinks: $0 may be a link
app_path="$(readlink -f -- "${BASH_SOURCE[0]}")"

export APP_NAME="dpkg-ayatana"
export VERSION="1.0.0-snapshot"
export TMP_DIR="/tmp/$APP_NAME"

mkdir -p "$TMP_DIR"
lockfile="$TMP_DIR/.lock"

# Check if there is a running instance of the script
if lslocks | grep -q "$lockfile"; then
   echo >&2 "Error: Another $APP_NAME command is running"
   exit 1
fi

# Obtain lock and run main.sh
flock -n "$lockfile" "$(dirname -- "$app_path")/main.sh" "$@"
