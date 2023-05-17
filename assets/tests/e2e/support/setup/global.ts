import fs from "fs";
import { FullConfig, chromium } from "@playwright/test";

import { AccountsRegisterPage } from "tests/e2e/accounts/register/page";
import { storageState } from "tests/e2e/support/constants";
import { testUserEmail, passwordValid } from "tests/support/constants";
import { textColorize } from "tests/support/helpers";

// expose shared state so that setup data can be accessed in teardown logic
export const state: { baseUrl?: string; sqlSandboxUserAgent?: string } = {};

async function globalSetup(config: FullConfig) {
  state.baseUrl = config.projects[0].use.baseURL;

  // create storageState.json if it doesn't already exist
  if (!fs.existsSync(storageState)) {
    console.log(
      textColorize(`File '${storageState}' doesn't exist. Creating it now...`)
    );

    fs.writeFileSync(storageState, "{}"); // create empty JSON file
  }

  // create new browser session (use shared state so teardown can access browser context)
  const browser = await chromium.launch();
  const page = await browser.newPage({ storageState: undefined });

  // register generic test user
  console.log(textColorize("Setup (global): Registering generic test user..."));
  const accountsRegisterPage = new AccountsRegisterPage(page);
  await accountsRegisterPage.goto();
  await accountsRegisterPage.register(testUserEmail, passwordValid);
}

export default globalSetup;
