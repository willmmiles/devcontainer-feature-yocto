#!/bin/bash

# This test file will be executed against one of the scenarios devcontainer.json test that
# includes the 'yocto' feature with "version": "zeus" option.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
# TODO - clone yocto base, try building something??
#check "execute command" bash -c "hello | grep 'hello, $(whoami)!'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
