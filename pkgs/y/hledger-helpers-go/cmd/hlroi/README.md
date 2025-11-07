# hlroi

hlroi is an abstraction on [`hledger roi`](https://hledger.org/dev/hledger.html#roi) for the calculation of return-on-investment on my journals.

## Configuration

To configure hlroi, you need to set the environment variable `HL_ROI_ACCOUNTS`.
The variable contains the JSON-representation of the [roi accounts configuration](../../internal/roi/roi.go#26).
The configuration contains groups of queries to analyze.

```json5
{
  "depot": {
    "investmentQuery": "acct:assets:Depot:",  // Must match all of the investment transactions
    "pnlQuery": "acct:revenue:Depot: acct:expenses:Depot:"  // Must match all value increasing/decreasing transactions
  },
}
```

For details on [query format](https://hledger.org/dev/hledger.html#queries) and [roi calculation](https://hledger.org/dev/hledger.html#roi), see the hledger documentation.

## Usage

`hlroi`, run without any arguments, will calculate the roi for all roi account groups over the entire period in the journal.
All of your configured queries are OR-ed to achieve this.

To analyze an individual group, run `hlroi -group <groupname>`.

To report the roi over intervals, use any of the static `hledger` report interval flags.
I.e. you can use everything except the manual `--period` periods.
