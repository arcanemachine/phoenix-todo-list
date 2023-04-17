import { defineConfig } from "@playwright/test";
import { devices } from "@playwright/test";

import { storageState } from "test/e2e/support/constants";

export default defineConfig({
  expect: {
    timeout: 1000 * 5, // timeout for a single `expect()` condition
  },
  fullyParallel: true, // run tests in parallel
  // fail if `.only()` in tests during CI run or during git `pre-commit` hook
  forbidOnly: !!process.env.CI || !!process.env.PRE_COMMIT,
  globalSetup: "e2e/support/setup/global.ts",
  globalTeardown: "e2e/support/teardown.ts",
  retries: process.env.CI ? 2 : 0, // retry on CI only
  reporter: "line",
  testDir: "./e2e",
  timeout: 1000 * 60, // timeout for a single test
  use: {
    actionTimeout: 0, // timeout for each action (0 for infinite timeout)
    baseURL: process.env.SERVER_URL_HTTP_TEST,
    storageState,
    trace: "on-first-retry", // collect trace when retrying the failed test
  },
  workers: process.env.CI ? 1 : undefined, // opt out of parallel tests on CI

  projects: [
    // {
    //   name: "setup-hello",
    //   testMatch: "e2e/support/setup/hello.ts",
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

  /* Folder for test artifacts such as screenshots, videos, traces, etc. */
  // outputDir: 'test-results/',

  /* Run your local dev server before starting the tests */
  webServer: {
    ignoreHTTPSErrors: true,
    command: "mix phx.server",
    env: {
      MIX_ENV: "test",
    },
    url: process.env.SERVER_URL_HTTPS_TEST,
    cwd: "../../",
  },
});
