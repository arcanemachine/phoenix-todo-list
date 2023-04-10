import type { PlaywrightTestConfig } from "@playwright/test";
import { devices } from "@playwright/test";

const storageState = "e2e/.auth/storageState.json";

const config: PlaywrightTestConfig = {
  testDir: "./e2e",

  expect: {
    timeout: 5 * 1000, // timeout for a single `expect()` condition
  },
  fullyParallel: true, // run tests in parallel
  // fail if `.only()` in tests during CI run or during git `pre-commit` hook
  forbidOnly: !!process.env.CI || !!process.env.PRE_COMMIT,
  // retries: process.env.CI ? 2 : 0, // retry on CI only
  retries: 3,
  reporter: "line",
  timeout: 60 * 1000, // wait time for a single test to finish
  use: {
    actionTimeout: 0, // timeout for each action (0 for infinite timeout)
    baseURL: process.env.SERVER_URL_HTTPS,
    storageState,
    trace: "on-first-retry", // collect trace when retrying the failed test
  },
  workers: process.env.CI ? 1 : undefined, // opt out of parallel tests on CI

  projects: [
    // {
    //   name: "hello-world",
    //   testMatch: "e2e/support/setup/hello-world.ts",
    // },
    {
      name: "use-authenticated-user",
      testMatch: "e2e/setup/use-authenticated-user.ts",
    },
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
        // storageState,
      },
      // dependencies: ["setup"],
    },

    {
      name: "firefox",
      use: {
        ...devices["Desktop Firefox"],
        contextOptions: {
          ignoreHTTPSErrors: true,
        },
        // storageState,
      },
      // dependencies: ["setup"],
    },

    {
      name: "webkit",
      use: {
        ...devices["Desktop Safari"],
        // storageState,
      },
      // dependencies: ["setup"],
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
