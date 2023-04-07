#!/bin/bash

cd $(dirname "$0")/../

# find all '*.spec.ts' and '*.spec.js' files that aren't in exempted directories, and run the tests when any change is detected in the files
while sleep 1; do find $app_dir -name '*.spec.ts' -o -name '*.spec.js' -not -path '*/node_modules/*' | entr ./scripts/playwright-test.sh "$@"; done
