package main

import (
	"fmt"
	"os"
	"slices"

	"github.com/go-git/go-git/v6"
)

var (
	ErrMultipleRemotesWithoutOrigin = fmt.Errorf("multiple remotes found, none of which is called 'origin'")
	ErrNoRemotes                    = fmt.Errorf("no remote found")
)

// FindRemote decides, which in a slice of remotes should be used as the default.
// It prefers 'origin' as the most widely used default name.
func FindRemote(remotes []string) (string, error) {
	if len(remotes) == 1 {
		return remotes[0], nil
	}

	if slices.Contains(remotes, "origin") {
		return "origin", nil
	}

	if len(remotes) > 1 {
		return "", ErrMultipleRemotesWithoutOrigin
	}

	return "", ErrNoRemotes
}

func main() {
	cwd, err := os.Getwd()
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to get current working directory: %s\n", err)
		os.Exit(1)
	}

	repo, err := git.PlainOpenWithOptions(cwd, &git.PlainOpenOptions{
		DetectDotGit: true,
	})
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to open git repository: %s\n", err)
		os.Exit(1)
	}

	remotes, err := repo.Remotes()
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to read remotes: %s\n", err)
		os.Exit(1)
	}

	remoteNames := make([]string, len(remotes))
	for i, remote := range remotes {
		remoteNames[i] = remote.Config().Name
	}

	remote, err := FindRemote(remoteNames)
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not determine default remote: %s", err.Error())
		os.Exit(1)
	}

	fmt.Printf("%s\n", remote)
}
