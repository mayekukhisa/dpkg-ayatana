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

function show_help {
   echo "Usage: $APP_NAME [OPTIONS]"
   echo ""
   echo "  A wrapper around Dpkg for installing packages that depend on the deprecated"
   echo "  libappindicator package"
   echo ""
   echo "Options:"
   echo "  --version              Report tool version and exit"
   echo "  -i, --install PACKAGE  Install package(s)"
   echo "  -h, --help             Show this message and exit"
}

function main {
   if [[ "$#" -eq 0 ]]; then
      show_help
      exit 1
   fi

   ARGS="$(getopt -n "$APP_NAME" -o ih -l version,install,help -- "$@")"
   eval set -- "$ARGS"

   op_install=false

   while :; do
      case "$1" in
      -i | --install)
         op_install=true
         shift
         ;;
      --version)
         echo "$VERSION"
         exit
         ;;
      -h | --help)
         show_help
         exit
         ;;
      --)
         shift
         break
         ;;
      esac
   done

   if $op_install; then
      # Test if running with superuser privilege
      if [[ "$EUID" -ne "0" ]]; then
         echo >&2 "Error: Requested operation requires superuser privilege"
         exit 1
      fi

      # Test if a positional argument was provided
      if [[ "$#" -eq 0 ]]; then
         echo >&2 "Error: Path to a package is required"
         exit 1
      fi

      dpkg -i -- "$@"
   fi
}

main "$@"
