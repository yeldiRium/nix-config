// package roi provides functions to parameterize the execution of the hledger
// roi command to allow for flexible reporting.
package roi

import (
	"context"
	"fmt"
	"maps"
	"os/exec"
	"slices"

	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"

	"github.com/yeldirium/nix-config/packages/y/hledger-helpers-go/internal/hledger"
)

var (
	ErrNoROIAccounts = fmt.Errorf("no roi accounts configured")
	ErrNoGroups      = fmt.Errorf("no groups for roi calculaton given")
	ErrUnknownGroup  = fmt.Errorf("given group missing from roi accounts")
)

type ROIAccountQueries struct {
	InvestmentQuery string `json:"investmentQuery"`
	PNLQuery        string `jsjon:"pnlQuery"`
}

type ROIAccounts map[string]ROIAccountQueries

type calculateROIOptions struct {
	roiAccounts    ROIAccounts
	groups         []string
	reportInterval hledger.ReportInterval
}

type CalculateROIOption func(*calculateROIOptions)

func WithGroups(groups []string) CalculateROIOption {
	return func(options *calculateROIOptions) {
		options.groups = groups
	}
}

func WithReportInterval(reportInterval hledger.ReportInterval) CalculateROIOption {
	return func(options *calculateROIOptions) {
		options.reportInterval = reportInterval
	}
}

func CalculateROI(ctx context.Context, roiAccounts ROIAccounts, opts ...CalculateROIOption) (*exec.Cmd, error) {
	span := trace.SpanFromContext(ctx)

	options := calculateROIOptions{
		roiAccounts: roiAccounts,
		groups:      slices.Collect(maps.Keys(roiAccounts)),
	}
	for _, opt := range opts {
		opt(&options)
	}

	span.SetAttributes(
		attribute.StringSlice("hlroi.selectedGroups", options.groups),
		attribute.StringSlice("hlroi.configuredGroups", slices.Sorted(maps.Keys(options.roiAccounts))),
	)

	args := []string{"roi", "--value=end"}

	if options.reportInterval != "" {
		args = append(args, fmt.Sprintf("--%s", options.reportInterval))
	}

	roiArgs, err := makeROIAccountsArgs(options.roiAccounts, options.groups)
	if err != nil {
		return nil, err
	}
	args = append(args, roiArgs.invQuery, roiArgs.pnlQuery)

	span.SetAttributes(
		attribute.StringSlice("hlroi.args", args),
	)

	return exec.CommandContext(ctx, "hledger", args...), nil
}

type accountsArgs struct {
	invQuery string
	pnlQuery string
}

func makeROIAccountsArgs(roiAccounts ROIAccounts, groups []string) (accountsArgs, error) {
	if len(roiAccounts) == 0 {
		return accountsArgs{}, ErrNoROIAccounts
	}
	if len(groups) == 0 {
		return accountsArgs{}, ErrNoGroups
	}

	args := accountsArgs{
		invQuery: "",
		pnlQuery: "",
	}

	spacer := ""
	spacerInBetween := " or "

	for _, group := range groups {
		roiAccount, ok := roiAccounts[group]
		if !ok {
			return accountsArgs{}, fmt.Errorf("%w: %s, available groups are %s", ErrUnknownGroup, group, slices.Sorted(maps.Keys(roiAccounts)))
		}
		args.invQuery += fmt.Sprintf("%s(%s)", spacer, roiAccount.InvestmentQuery)
		args.pnlQuery += fmt.Sprintf("%s(%s)", spacer, roiAccount.PNLQuery)

		spacer = spacerInBetween
	}

	args.invQuery = fmt.Sprintf("--investment=expr:'%s'", args.invQuery)
	args.pnlQuery = fmt.Sprintf("--profit-loss=expr:'%s'", args.pnlQuery)

	return args, nil
}
