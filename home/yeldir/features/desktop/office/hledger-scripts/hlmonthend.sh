#!/usr/bin/env sh


ACTIVE_MONTH=$(date --date '-22days +1month' +%m)
ACTIVE_YEAR=$(date --date '-22days +1month' +%Y)

ACTIVE_MONTH_END="${ACTIVE_YEAR}-${ACTIVE_MONTH}-23"

echo "${ACTIVE_MONTH_END}"
