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

function show_help {
   echo "Usage: $APP_NAME [OPTIONS]"
   echo ""
   echo "  A wrapper around dpkg for installing packages that depend on the"
   echo "  libappindicator package"
   echo ""
   echo "Options:"
   echo "  --version   Report tool version and exit"
   echo "  -h, --help  Show this message and exit"
}

function main {
   if [[ "$#" -eq 0 ]]; then
      show_help
      exit 1
   fi

   ARGS="$(getopt -n "$APP_NAME" -o h -l version,help -- "$@")"
   eval set -- "$ARGS"

   while :; do
      case "$1" in
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
}

main "$@"
