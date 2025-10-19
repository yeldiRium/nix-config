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
	ErrNoDefaultBranch = fmt.Errorf("could not find either a 'main' or a 'master' branch")
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

func FindDefaultBranch(branches []string) (string, error) {
	if slices.Contains(branches, "main") {
		return "main", nil
	}

	if slices.Contains(branches, "master") {
		return "master", nil
	}

	return "", ErrNoDefaultBranch
}

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	cancelOnSignal(cancel)

	out, err := exec.CommandContext(ctx, "git", "branch", "--format", "%(refname:short)").CombinedOutput()
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to read git branches: %s\n%s\n", err.Error(), out)
		os.Exit(1)
	}

	branches := strings.Split(string(out), "\n")
	remote, err := FindDefaultBranch(branches)
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not determine default branch: %s", err.Error())
	}

	fmt.Printf("%s\n", remote)
}
