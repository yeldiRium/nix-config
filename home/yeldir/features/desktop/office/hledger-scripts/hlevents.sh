#!/usr/bin/env zsh

help() {
  echo "Usage: hlevents"
  echo ""
  echo "  -p|--pivot  Groups transactions by event instead of account"
  echo "  -b|--begin  Override begin date. Default is 6 months ago"
  echo "  -e|--end    Override end date. Default is in 6 months"
  echo "     --cf     Use cashflow report instead of incomestatement. Shows total per event. Use together with -p"
  echo "     --help   Show this help"
}

PIVOT_FLAG='acct'
BEGIN_DATE=$(date --date '-6 months' '+%Y-%m')
END_DATE=$(date --date '+6 months' '+%Y-%m')
REPORT='incomestatement'

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--pivot)
      PIVOT_FLAG='event'
      shift;
      ;;
    -b|--begin)
      BEGIN_DATE="${2}"
      shift;
      shift;
      ;;
    -e|--end)
      END_DATE="${2}"
      shift;
      shift;
      ;;
    --cf)
      REPORT='cashflow'
      shift;
      ;;
    --help)
      help
      exit 0
      shift;
      ;;
    *)
      echo "Unknown option ${1}"
      echo ""
      help
      exit 1
      ;;
  esac
done

echo "pivoting: ${PIVOT_FLAG}"
echo ""

hledger "${REPORT}" \
    --monthly \
    --market \
    --begin "${BEGIN_DATE}" \
    --end "${END_DATE}" \
    --forecast \
    --pivot "${PIVOT_FLAG}" \
    --row-total \
    "tag:event"