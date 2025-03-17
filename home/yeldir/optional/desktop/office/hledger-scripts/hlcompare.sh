#!/usr/bin/env zsh

help() {
  echo "Usage: hlcompare [-d|--day-of-month number]"
  echo ""
  echo "  -d|--day-of-month  Day of the month on which to compare the previous months"
  echo "     --help          Show this help"
}

DAY_OF_MONTH=$(date --date '+1 days' '+%d')

while [ $# -gt 0 ]; do
  case $1 in
    -d|--day-of-month)
      DAY_OF_MONTH="${2}"
      shift; shift;
      ;;
    --help)
      help
      exit 0
      ;;
    *)
      echo "Unknown option ${1}"
      echo ""
      help
      exit 1
      ;;
  esac
done

echo "day of month: ${DAY_OF_MONTH}"

BEGIN_DATE=$(date --date '-6 months' '+%Y-%m')

hledger balancesheet \
	--market \
	--period "every ${DAY_OF_MONTH}th day" \
	--begin "${BEGIN_DATE}" \
	--end tomorrow \
	--depth 4 \
	--tree \
	"${HL_MAIN_ACCOUNTS[@]}"
