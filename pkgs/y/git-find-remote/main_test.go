package main

import (
	"errors"
	"testing"
)

func TestFindRemote(t *testing.T) {
	t.Parallel()

	t.Run("if 'origin' is contained in the slice, returns 'origin'", func(t *testing.T) {
		t.Parallel()

		remotes := []string{
			"dingus",
			"origin",
			"uiae",
		}

		foundRemote, err := FindRemote(remotes)
		if err != nil {
			t.Error("it should not have returned an error")
		}
		if foundRemote != "origin" {
			t.Errorf("expected 'origin', got %s", foundRemote)
		}
	})

	t.Run("if the slice contains only one element, returns it", func(t *testing.T) {
		t.Parallel()

		remotes := []string{
			"definitely-not-origin",
		}

		foundRemote, err := FindRemote(remotes)
		if err != nil {
			t.Error("it should not have returned an error")
		}
		if foundRemote != "definitely-not-origin" {
			t.Errorf("expected 'definitely-not-origin', got %s", foundRemote)
		}
	})

	t.Run("if the slice returns multiple elements and none is 'origin', returns an error", func(t *testing.T) {
		t.Parallel()

		remotes := []string{
			"not-origin",
			"also-not-origin",
			"not-origin-again",
		}

		_, err := FindRemote(remotes)
		if err == nil {
			t.Error("it should have returned an error")
		}
		if !errors.Is(err, ErrMultipleRemotesWithoutOrigin) {
			t.Errorf("expected error ErrMultipleRemotesWithoutOrigin, got %s", err.Error())
		}
	})

	t.Run("if the slice is empty, returns an error", func(t *testing.T) {
		t.Parallel()

		remotes := []string{}

		_, err := FindRemote(remotes)
		if err == nil {
			t.Error("it should have returned an error")
		}
		if !errors.Is(err, ErrNoRemotes) {
			t.Errorf("expected error ErrNoRemotes, got %s", err.Error())
		}
	})
}
