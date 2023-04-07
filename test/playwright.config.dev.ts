import type { PlaywrightTestConfig } from "@playwright/test";
import { devices } from "@playwright/test";

const config: PlaywrightTestConfig = {
  testDir: "./e2e",

  timeout: 60 * 1000, // wait time for a single test to finish
  expect: {
    timeout: 5 * 1000, // timeout for a single `expect()` condition
  },

  fullyParallel: true, // run tests in parallel
  forbidOnly: !!process.env.CI, // CI builds fail if `test.only` in source code
  retries: process.env.CI ? 2 : 0, // retry on CI only
  workers: process.env.CI ? 1 : undefined, // opt out of parallel tests on CI
  reporter: "line",
  use: {
    actionTimeout: 0, // timeout for each action. defaults to 0 (infinite)
    baseURL: `http://localhost:${process.env.PORT || "4000"}`,
    trace: "on-first-retry", // collect trace when retrying the failed test
  },

  projects: [
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
      },
    },

    {
      name: "firefox",
      use: {
        ...devices["Desktop Firefox"],
      },
    },

    {
      name: "webkit",
      use: {
        ...devices["Desktop Safari"],
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
  // webServer: {
  //   command: 'npm run start',
  //   port: 3000,
  // },
};

export default config;
