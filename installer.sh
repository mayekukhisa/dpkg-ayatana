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

function download_file {
   if ! wget -q -P "$2" -- "$1"; then
      echo "Failed!"
      echo >&2 "Error: Check your internet connection and try again"
      exit 1
   fi
}

function main {
   # Test if running as root
   if [[ "$EUID" -ne 0 ]]; then
      echo >&2 "Error: Run with superuser privilege"
      exit 1
   fi

   url_base="https://raw.githubusercontent.com/mayekukhisa/dpkg-ayatana/main"

   launch_script_url="$url_base/bin/dpkg-ayatana.sh"
   main_script_url="$url_base/bin/main.sh"
   license_url="$url_base/LICENSE"

   install_root_dir="/opt/dpkg-ayatana"
   install_bin_dir="$install_root_dir/bin"

   echo -n "Installing Dpkg-ayatana ... "

   # Wget doesn't let you overwrite existing files with the -P option.
   # Therefore, clear the installation directory before downloading new files.
   rm -rf "${install_root_dir:?}/"*

   download_file "$launch_script_url" "$install_bin_dir"
   download_file "$main_script_url" "$install_bin_dir"
   download_file "$license_url" "$install_root_dir"

   # Unix file permissions are not transferred over HTTP.
   # Add permission to execute files in the bin diretory.
   chmod +x -- "$install_bin_dir/"*

   if ! hash dpkg-ayatana 2>/dev/null; then
      ln -s "$install_bin_dir/$(basename -- "$launch_script_url")" -- "/usr/local/bin/dpkg-ayatana"
   fi

   echo "Done!"
   echo "Run 'dpkg-ayatana --help' for usage info"
}

main
