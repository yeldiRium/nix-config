#!/usr/bin/env zsh

TREE_FLAGS='--tree'

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--no-tree)
      TREE_FLAGS=''
      shift;
      ;;
    *)
      echo "Unknown option ${1}"
      exit 1
      ;;
  esac
done

hledger balancesheetequity \
    --historical \
    --market \
    "${TREE_FLAGS}" \
    date:today \
    "${HL_MAIN_ACCOUNTS[@]}"
