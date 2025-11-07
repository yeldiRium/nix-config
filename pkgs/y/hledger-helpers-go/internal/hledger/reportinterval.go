package hledger

import (
	"fmt"
	"slices"
	"strings"

	"github.com/yeldirium/nix-config/packages/y/hledger-helpers-go/internal/cli"
)

type ReportInterval string

const (
	ReportIntervalDaily     ReportInterval = "daily"
	ReportIntervalWeekly    ReportInterval = "weekly"
	ReportIntervalMonthly   ReportInterval = "monthly"
	ReportIntervalQuarterly ReportInterval = "quarterly"
	ReportIntervalYearly    ReportInterval = "yearly"
)

var (
	ErrInvalidReportInterval = fmt.Errorf("invalid report interval")
	ReportIntervalValues     = []ReportInterval{ReportIntervalDaily, ReportIntervalWeekly, ReportIntervalMonthly, ReportIntervalQuarterly, ReportIntervalYearly}
	ReportIntervalFlagSet    = cli.EnumFlagSet[ReportInterval]{
		cli.EnumFlagMapping[ReportInterval]{
			Name:    "daily",
			Aliases: []string{"daily", "D"},
			Value:   ReportIntervalDaily,
		},
		cli.EnumFlagMapping[ReportInterval]{
			Name:    "weekly",
			Aliases: []string{"weekly", "W"},
			Value:   ReportIntervalWeekly,
		},
		cli.EnumFlagMapping[ReportInterval]{
			Name:    "monthly",
			Aliases: []string{"monthly", "M"},
			Value:   ReportIntervalMonthly,
		},
		cli.EnumFlagMapping[ReportInterval]{
			Name:    "quarterly",
			Aliases: []string{"quarterly", "Q"},
			Value:   ReportIntervalQuarterly,
		},
		cli.EnumFlagMapping[ReportInterval]{
			Name:    "yearly",
			Aliases: []string{"yearly", "Y"},
			Value:   ReportIntervalYearly,
		},
	}
)

// ParseReportInterval parses the possible values that hledger takes for report
// interval configuration. It accepts values that may start with one or two
// dashes to allow for values given as CLI arguments.
func ParseReportInterval(input string) (output ReportInterval, ok bool) {
	input = strings.TrimPrefix(input, "-")
	input = strings.TrimPrefix(input, "--")

	if !slices.ContainsFunc(ReportIntervalValues, func(option ReportInterval) bool {
		return string(option) == input
	}) {
		return "", false
	}

	return ReportInterval(input), true
}

// ParseReportInterval parses the possible values that hledger takes for report
// interval configuration and writes the parsed value to output. It accepts
// values that may start with one or two dashes to allow for values given as CLI
// arguments.
func ParseReportIntervalVar(output *ReportInterval, input string) error {
	interval, ok := ParseReportInterval(input)
	if !ok {
		return fmt.Errorf("%w: %s is not allowed", ErrInvalidReportInterval, input)
	}

	*output = interval

	return nil
}
