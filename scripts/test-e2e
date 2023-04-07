#!/bin/bash

cd $(dirname "$0")/../test

if [ "$MIX_ENV" == "" ]; then
  MIX_ENV=dev
fi

npx playwright test --config=playwright.config.$MIX_ENV.ts "$@"
