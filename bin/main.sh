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
   echo "  -i, --install PACKAGE  Rebuild and install package(s)"
   echo "  -h, --help             Show this message and exit"
}

function rebuild_package {
   # Validate file path
   if [[ "$1" != *deb || ! -e "$1" ]]; then
      echo "Skipped $1 ... File not found or not a Debian package"
      return
   fi

   package_info="$(dpkg -I -- "$1")"
   package_name="$(awk -- '/Package:/ { print $2 }' <<<"$package_info")"
   package_version="$(awk -- '/Version:/ { print $2 }' <<<"$package_info")"

   # Rebuild package if associated with libappindicator
   if grep -q "libappindicator" <<<"$package_info"; then
      cd -- "$TMP_DIR"
      echo "Rebuilding $package_name ($package_version) ..."

      replacement_package="$TMP_DIR/$package_name-$package_version.deb"

      # Replace libappindicator with libayatana-appindicator in package dependencies
      dpkg-deb -R -- "$1" "$package_name"
      sed -i -- "s/libappindicator/libayatana-appindicator/g" "$package_name/DEBIAN/control"
      dpkg-deb -b -- "$package_name" "$replacement_package"

      echo "Overwriting $1 ..."
      cp -f -- "$replacement_package" "$1"
   else
      echo "Skipped rebuilding $package_name ($package_version) ... Package ok!"
   fi

   cleared_packages+=("$1")
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

      cleared_packages=() # An array for holding packages cleared for installation

      for file_path in "$@"; do
         rebuild_package "$(readlink -f -- "$file_path")"
      done

      if [[ "${#cleared_packages[@]}" -ne 0 ]]; then
         dpkg -i -- "${cleared_packages[@]}"
      fi
   fi
}

main "$@"
