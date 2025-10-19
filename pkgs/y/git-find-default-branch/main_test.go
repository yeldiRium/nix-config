package main

import (
	"errors"
	"testing"
)

func TestFindDefaultBranch(t *testing.T) {
	t.Parallel()

	t.Run("returns main, if a main branch exists", func(t *testing.T) {
		t.Parallel()

		branches := []string{
			"bar",
			"main",
			"foo",
		}

		foundBranch, err := FindDefaultBranch(branches)

		if err != nil {
			t.Error("should not have returned an error")
		}
		if foundBranch != "main" {
			t.Errorf("expected main, got %s", foundBranch)
		}
	})

	t.Run("returns main, if a main branch exists, even if a master branch exists", func(t *testing.T) {
		t.Parallel()

		branches := []string{
			"bar",
			"main",
			"foo",
			"master",
		}

		foundBranch, err := FindDefaultBranch(branches)

		if err != nil {
			t.Error("should not have returned an error")
		}
		if foundBranch != "main" {
			t.Errorf("expected main, got %s", foundBranch)
		}
	})

	t.Run("returns master, if a master and no main branch exists", func(t *testing.T) {
		t.Parallel()

		branches := []string{
			"bar",
			"foo",
			"master",
		}

		foundBranch, err := FindDefaultBranch(branches)

		if err != nil {
			t.Error("should not have returned an error")
		}
		if foundBranch != "master" {
			t.Errorf("expected master, got %s", foundBranch)
		}
	})

	t.Run("returns an error, if neither main nor master branch exists", func(t *testing.T) {
		t.Parallel()

		branches := []string{
			"bar",
			"foo",
		}

		_, err := FindDefaultBranch(branches)

		if err == nil {
			t.Error("should have returned an error")
		}
		if !errors.Is(err, ErrNoDefaultBranch) {
			t.Errorf("expected error ErrNoDefaultBranch, got %s", err.Error())
		}
	})
}
