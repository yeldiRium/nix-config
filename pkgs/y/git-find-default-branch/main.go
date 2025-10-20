package main

import (
	"fmt"
	"os"
	"slices"
	"strings"

	"github.com/go-git/go-git/v6"
)

var (
	ErrNoDefaultBranch = fmt.Errorf("could not find either a 'main' or a 'master' branch")
)

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

	branches, err := repo.Branches()
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to find branches: %s\n", err)
		os.Exit(1)
	}

	branchNames := make([]string, 0)
	for {
		branch, err := branches.Next()
		if err != nil {
			break
		}
		branchName := string(branch.Name())
		shortBranchName, _ := strings.CutPrefix(branchName, "refs/heads/")

		branchNames = append(branchNames, shortBranchName)
	}

	remote, err := FindDefaultBranch(branchNames)
	if err != nil {
		fmt.Fprintf(os.Stderr, "could not determine default branch: %s", err)
		os.Exit(1)
	}

	fmt.Printf("%s\n", remote)
}
