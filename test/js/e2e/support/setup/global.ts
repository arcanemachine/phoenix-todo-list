import fs from "fs";
import { chromium, FullConfig } from "@playwright/test";

import { AccountsRegisterPage } from "test/e2e/accounts/register/page";
import { storageState } from "test/e2e/support/constants";
import { testUserEmail, passwordValid } from "test/support/constants";
import { textColorize } from "test/support/helpers";

// async function globalSetup(config: FullConfig) {
async function globalSetup() {
  // create storageState.json if it doesn't already exist
  if (!fs.existsSync(storageState)) {
    console.log(
      textColorize(`File '${storageState}' doesn't exist. Creating it now...`)
    );

    fs.writeFileSync(storageState, "{}"); // create empty JSON file
  }

  // create new browser session
  const browser = await chromium.launch();
  const page = await browser.newPage({ storageState: undefined });

  // register generic test user
  console.log(textColorize("Setup (global): Registering generic test user..."));
  const accountsRegisterPage = new AccountsRegisterPage(page);
  await accountsRegisterPage.goto();
  await accountsRegisterPage.register(testUserEmail, passwordValid);
}

export default globalSetup;
