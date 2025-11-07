package roi

import (
	"fmt"
	"testing"
)

func TestMakeROIAccountsArgs(t *testing.T) {
	t.Parallel()

	t.Run("returns an error if no roi accounts are given", func(t *testing.T) {
		t.Parallel()

		_, err := makeROIAccountsArgs(ROIAccounts{}, []string{})

		if err == nil {
			t.Error("expected to return an error")
		}
	})

	t.Run("returns an error if no groups are given", func(t *testing.T) {
		t.Parallel()

		_, err := makeROIAccountsArgs(ROIAccounts{
			"foo": ROIAccountQueries{},
		}, []string{})

		if err == nil {
			t.Error("expected to return an error")
		}
	})

	t.Run("builds args from the configured roi accounts and the given groups", func(t *testing.T) {
		t.Parallel()
		roiAccounts := ROIAccounts{
			"foo": {
				InvestmentQuery: "foo-i-1 foo-i-2",
				PNLQuery:        "foo-p-1 foo-p-2 foo-p-3",
			},
			"bar": {
				InvestmentQuery: "bar-i-1",
				PNLQuery:        "bar-p-1",
			},
			"dingus": {
				InvestmentQuery: "dingus-i-1 dingus-i-2",
				PNLQuery:        "dingus-p-1",
			},
		}

		testInputs := []struct {
			groups   []string
			expected accountsArgs
		}{
			{
				groups: []string{"foo"},
				expected: accountsArgs{
					invQuery: "--investment=expr:'(foo-i-1 foo-i-2)'",
					pnlQuery: "--profit-loss=expr:'(foo-p-1 foo-p-2 foo-p-3)'",
				},
			},
			{
				groups: []string{"foo", "dingus"},
				expected: accountsArgs{
					invQuery: "--investment=expr:'(foo-i-1 foo-i-2) or (dingus-i-1 dingus-i-2)'",
					pnlQuery: "--profit-loss=expr:'(foo-p-1 foo-p-2 foo-p-3) or (dingus-p-1)'",
				},
			},
		}

		for i, testInput := range testInputs {
			t.Run(fmt.Sprintf("table test case %d", i), func(t *testing.T) {
				t.Parallel()

				args, err := makeROIAccountsArgs(roiAccounts, testInput.groups)

				if err != nil {
					t.Errorf("should not have returned an error, but returned '%s'", err.Error())
				}

				if args.invQuery != testInput.expected.invQuery || args.pnlQuery != testInput.expected.pnlQuery {
					t.Errorf("expected %v, but got %v", testInput.expected, args)
				}
			})
		}
	})
}
