#!/usr/bin/env zsh

hledger balancesheetequity \
    --historical \
    --market \
    --empty \
    --end "$(hlmonthend)" \
    --forecast \
    "${HL_MAIN_ACCOUNTS[@]}"
