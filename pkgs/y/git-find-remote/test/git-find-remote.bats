#!/usr/bin/env bats

set -euo pipefail

setup() {
	bats_load_library bats-support
	bats_load_library bats-assert

	DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
	# make executable visible to PATH
	PATH="$DIR/..:$PATH"

	tmp=$(mktemp --directory --tmpdir bats-gitfindremote-XXXXXXXXXX)
	cd "${tmp}"
	git init
}

teardown() {
	cd -
	rm -rf "${tmp}"
}

@test 'returns origin if it is among the remotes' {
	git remote add foo foo
	git remote add origin origin
	git remote add zap zap

	run git-find-remote
	assert_success
	assert_output 'origin'
}

@test 'returns the only existing remote' {
	git remote add foo foo

	run git-find-remote
	assert_success
	assert_output 'foo'
}

@test 'fails if no remote exists' {
	run git-find-remote
	assert_failure
}

@test 'fails if more than one remote exists and none is called origin' {
	git remote add foo foo
	git remote add zap zap

	run git-find-remote
	assert_failure
}
