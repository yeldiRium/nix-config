#!/usr/bin/env zsh

help() {
  echo "Usage: hlbudget [-v|--verbose] [-m|--months]"
  echo ""
  echo "  -v|--verbose  Include empty accounts in output"
  echo "  -m|--months   Override how many months into the the past the budget should show"
  echo "  -p|--period   Override the period by which the budget is grouped. Try 'monthly', 'quarterly' or 'yearly'."
  echo "     --help     Show this help"
}

VERBOSE_FLAGS=''
MONTHS=5
PERIOD='monthly'

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
    -p|--period)
      PERIOD="${2}"
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
echo "period: ${PERIOD}"

BUDGET_ACCOUNTS=(
      'acct:expenses:Drugs'
      'acct:expenses:Food'
      'acct:expenses:Gift'
      'acct:expenses:Groceries'
      'acct:expenses:Hobby'
      'acct:expenses:Living Space'
      'acct:expenses:Tips'
  # Projects are budgeted separately.
  'not:tag:project'
)

START_MONTH=$(date --date "-${MONTHS}month" +%m)
START_YEAR=$(date --date "-${MONTHS}month" +%Y)

START_DATE="${START_YEAR}-${START_MONTH}"

hledger balance \
  --value=end \
  --empty \
  "--${PERIOD}" \
  --begin="${START_DATE}" \
  --budget \
  --average "${VERBOSE_FLAGS}" \
  --tree \
  --sort-amount \
  --color=always \
  "${BUDGET_ACCOUNTS[@]}"
