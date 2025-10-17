package main

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"slices"
	"strings"

	"golang.org/x/sys/unix"
)

var (
	ErrMultipleRemotesWithoutOrigin = fmt.Errorf("multiple remotes found, none of which is called 'origin'")
	ErrNoRemotes                    = fmt.Errorf("no remote found")
)

func cancelOnSignal(cancel context.CancelFunc) {
	signals := make(chan os.Signal, 1)
	signal.Notify(
		signals,
		unix.SIGHUP,
		unix.SIGINT,
		unix.SIGTERM,
	)
	go func() {
		sig := <-signals
		fmt.Printf("Caught signal '%s', exiting...\n", sig)
		cancel()
	}()
}

// FindRemote decides, which in a slice of remotes should be used as the default.
// It prefers 'origin' as the most widely used default name.
func FindRemote(remotes []string) (string, error) {
	if slices.Contains(remotes, "origin") {
		return "origin", nil
	}

	if len(remotes) == 1 {
		return remotes[0], nil
	}

	if len(remotes) > 1 {
		return "", ErrMultipleRemotesWithoutOrigin
	}

	return "", ErrNoRemotes
}

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	cancelOnSignal(cancel)

	out, err := exec.CommandContext(ctx, "git", "remote").Output()
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to read git remotes: %s\n", err.Error())
		os.Exit(1)
	}

	remotes := strings.Split(string(out), "\n")
	remote, err := FindRemote(remotes)
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not determine default remote: %s", err.Error())
	}

	fmt.Printf("%s\n", remote)
}
