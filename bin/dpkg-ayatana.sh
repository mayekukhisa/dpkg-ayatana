#!/usr/bin/env bash

# Copyright (c) 2022 Mayeku Khisa
#
# Licensed under the MIT License.
# You may not use this file except in compliance with the License as
# appearing in the LICENSE file included in the root of this source tree.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# Resolve symlinks: $0 may be a link
app_path="$(readlink -f -- "${BASH_SOURCE[0]}")"

export APP_NAME="dpkg-ayatana"
export VERSION="1.0.0"
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
