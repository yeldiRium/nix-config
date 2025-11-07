package telemetry

import (
	"context"
	"fmt"
	"io"
	"os"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/codes"
	"go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/sdk/resource"
	"go.opentelemetry.io/otel/sdk/trace"
	t "go.opentelemetry.io/otel/trace"
)

type Telemetry struct {
	Tracer t.Tracer
}

// SetupTelemetry sets up an otel trace provider that exports to stdout.
// This might seem overkill, but I like to instrument my applications with
// structured events an otel traces are a great tool for that.
// Using the same approach in all applications also improves the habit of
// building observable applications that work well in cloud contexts.
func SetupTelemetry(ctx context.Context, serviceName string, writer io.Writer) (*Telemetry, func(context.Context) error, error) {
	resource, err := resource.New(ctx, resource.WithAttributes(
		attribute.String("service.name", "serviceName"),
	))
	if err != nil {
		return nil, nil, err
	}

	traceExporter, err := stdouttrace.New(
		stdouttrace.WithWriter(writer),
		stdouttrace.WithPrettyPrint(),
	)
	if err != nil {
		return nil, nil, err
	}

	traceProvider := trace.NewTracerProvider(
		trace.WithResource(resource),
		trace.WithSyncer(traceExporter),
	)

	otel.SetTracerProvider(traceProvider)
	tracer := traceProvider.Tracer("")

	return &Telemetry{
		Tracer: tracer,
	}, traceProvider.Shutdown, nil
}

// WithTelemetry wraps a function that takes a context. It sets up telemetry,
// starts a span and injects the span into the functions context.
// This is intended as a wrapper for one-shot functions that should be instru-
// mented with telemetry and need their own entire context.
//
// This is overkill for most uses, but necessary for CLI commands that emit a
// root span for their run.
func WithTelemetry(ctx context.Context, serviceName string, writer io.Writer, fn func(context.Context) error) error {
	telemetry, shutdown, err := SetupTelemetry(ctx, serviceName, os.Stdout)
	if err != nil {
		fmt.Printf("failed to setup telemetry: %s", err.Error())
	} else {
		defer func() {
			_ = shutdown(ctx)
		}()
		ctxWithSpan, span := telemetry.Tracer.Start(ctx, serviceName)
		defer span.End()
		ctx = ctxWithSpan
	}

	span := t.SpanFromContext(ctx)

	err = fn(ctx)
	if err != nil {
		span.RecordError(err)
		span.SetStatus(codes.Error, err.Error())
	}

	return err
}
