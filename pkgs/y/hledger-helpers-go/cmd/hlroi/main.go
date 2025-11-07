package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"os"

	"github.com/yeldirium/nix-config/packages/y/hledger-helpers-go/internal/hledger"
	"github.com/yeldirium/nix-config/packages/y/hledger-helpers-go/internal/roi"
	"github.com/yeldirium/nix-config/packages/y/hledger-helpers-go/internal/telemetry"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"
)

const (
	EnvROIAccounts = "HL_ROI_ACCOUNTS"
)

var (
	group          string
	reportInterval hledger.ReportInterval
	debug          bool
)

func mainContext(ctx context.Context) error {
	span := trace.SpanFromContext(ctx)
	span.SetAttributes(
		attribute.String("cli.flag.group", group),
		attribute.String("cli.flag.reportInterval", string(reportInterval)),
		attribute.Bool("cli.flag.debug", debug),
	)

	envROIAccounts, ok := os.LookupEnv(EnvROIAccounts)
	if !ok {
		return fmt.Errorf("please set environment variable %s to a json representation of your roi accounts", EnvROIAccounts)
	}

	roiAccounts := roi.ROIAccounts{}
	err := json.Unmarshal([]byte(envROIAccounts), &roiAccounts)
	if err != nil {
		return fmt.Errorf("failed to parse roi accounts from environment variable %s: %w, content is %s", EnvROIAccounts, err, envROIAccounts)
	}

	options := []roi.CalculateROIOption{}
	if group != "" {
		options = append(options, roi.WithGroups([]string{group}))
	}
	if reportInterval != "" {
		options = append(options, roi.WithReportInterval(reportInterval))
	}

	cmd, err := roi.CalculateROI(ctx, roiAccounts, options...)
	if err != nil {
		return fmt.Errorf("failed to calculate roi: %w", err)
	}
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	return cmd.Run()
}

func main() {
	ctx := context.Background()

	flag.StringVar(&group, "group", "", fmt.Sprintf("group for which to calculate roi. must be present in the roi accounts in %s. if omitted, all groups are calculated", EnvROIAccounts))
	hledger.ReportIntervalFlagSet.MakeFlags(&reportInterval, "report-interval", "multiperiod report interval")
	flag.BoolVar(&debug, "debug", false, "print debug information")
	flag.Parse()

	var err error
	if debug {
		err = telemetry.WithTelemetry(ctx, "hlroi", os.Stdout, mainContext)
	} else {
		err = mainContext(ctx)
	}
	if err != nil {
		fmt.Printf("%s\n", err.Error())
		os.Exit(1)
	}
}
