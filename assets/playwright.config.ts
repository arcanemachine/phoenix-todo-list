import { defineConfig } from "@playwright/test";
import { devices } from "@playwright/test";

import { baseUrl } from "tests/support/constants";
import { storageState } from "tests/e2e/support/constants";

export default defineConfig({
  expect: {
    timeout: 1000 * 10, // timeout for a single `expect()` condition
  },
  fullyParallel: true, // run tests in parallel
  forbidOnly: !!process.env.CI, // fail if `.only()` in tests during CI
  globalSetup: "tests/e2e/support/setup/global.ts",
  // globalTeardown: "tests/e2e/support/teardown.ts",
  outputDir: "tests/e2e/test-results.ignore",
  retries: process.env.CI ? 2 : 0, // retry on CI only
  reporter: "line",
  testDir: "tests/e2e",
  timeout: 1000 * 60, // timeout for a single test
  use: {
    actionTimeout: 0, // timeout for each action (0 for infinite timeout)
    baseURL: baseUrl,
    storageState,
    trace: "on-first-retry", // collect trace when retrying the failed test
  },
  workers: process.env.CI ? 1 : undefined, // opt out of parallel tests on CI

  projects: [
    // {
    //   name: "setup-example",
    //   testMatch: "tests/e2e/support/setup/example.ts",
    // },
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
        storageState,
      },
      // dependencies: ["setup-hello"],
    },
    {
      name: "firefox",
      use: {
        ...devices["Desktop Firefox"],
        contextOptions: {
          ignoreHTTPSErrors: true,
        },
        storageState,
      },
    },

    {
      name: "webkit",
      use: {
        ...devices["Desktop Safari"],
        storageState,
      },
    },

    /* Test against mobile viewports. */
    // {
    //   name: 'Mobile Chrome',
    //   use: {
    //     ...devices['Pixel 5'],
    //   },
    // },
    // {
    //   name: 'Mobile Safari',
    //   use: {
    //     ...devices['iPhone 12'],
    //   },
    // },

    /* Test against branded browsers. */
    // {
    //   name: 'Microsoft Edge',
    //   use: {
    //     channel: 'msedge',
    //   },
    // },
    // {
    //   name: 'Google Chrome',
    //   use: {
    //     channel: 'chrome',
    //   },
    // },
  ],

  /* Run your local dev server before starting the tests */
  webServer: {
    ignoreHTTPSErrors: true,
    command: "mix phx.server",
    env: {
      MIX_ENV: "test",
    },
    url: baseUrl,
    cwd: "../",
  },
});
