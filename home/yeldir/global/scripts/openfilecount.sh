#!/usr/bin/env bash
set -e

nix-shell -p lsof --run "lsof | awk '{ print \$2 \" \" \$1; }' | sort -rn | uniq -c | sort -rn | head -20"
