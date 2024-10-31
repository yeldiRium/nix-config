#!/usr/bin/env zsh

DAY_OF_MONTH=$(date --date '+1 days' '+%d')
BEGIN_DATE=$(date --date '-6 months' '+%Y-%m')

hledger balancesheet \
	--market \
	--period "every ${DAY_OF_MONTH}th day" \
	--begin "${BEGIN_DATE}" \
	--end tomorrow \
	--depth 4 \
	--tree \
	"${HL_MAIN_ACCOUNTS[@]}"
