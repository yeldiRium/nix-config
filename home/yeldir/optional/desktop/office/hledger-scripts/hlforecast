#!/usr/bin/env zsh

help() {
  echo "Usage: hlforecast [-v|--verbose] [-m|--months]"
  echo ""
  echo "  -v|--verbose  Include empty accounts in output"
  echo "  -m|--months   Override how many months into the future the forecast should show"
  echo "     --help     Show this help"
}

VERBOSE_FLAGS=''
MONTHS=12

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE_FLAGS='--empty'
      shift;
      ;;
    -m|--months)
      MONTHS="${2}"
      shift; shift;
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

echo "verbose flags: ${VERBOSE_FLAGS}"
echo "months: ${MONTHS}"

START_MONTH=$(date +%m)
START_YEAR=$(date +%Y)
START_DATE="${START_YEAR}-${START_MONTH}"

END_MONTH=$(date --date "+${MONTHS}month" +%m)
END_YEAR=$(date --date "+${MONTHS}month" +%Y)
END_DATE="${END_YEAR}-${END_MONTH}"

hledger incomestatement\
  --value=end\
  --monthly\
  --begin="${START_DATE}"\
  --end="${END_DATE}"\
  --tree\
  --forecast\
  --color=always

hledger balancesheet\
  --value=end\
  --period "every 23nd day"\
  --begin="${START_DATE}"\
  --end="${END_DATE}"\
  --forecast\
  --color=always\
  Cash Savings "Credit Card"
