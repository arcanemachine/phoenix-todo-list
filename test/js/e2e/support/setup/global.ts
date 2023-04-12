import fs from "fs";
import { chromium, FullConfig } from "@playwright/test";

import { testUserEmail, passwordValid } from "test/support/constants";
import { ConsoleColors, textColorize } from "test/support/helpers";
import { AccountsRegisterPage } from "e2e/accounts/register/page";
import { storageState } from "e2e/support/constants";

async function globalSetup(config: FullConfig) {
  config; // this line is only here so the linter will be quiet

  // create storageState.json if it doesn't already exist
  if (!fs.existsSync(storageState)) {
    console.log(`File '${storageState}' doesn't exist. Creating it now...`);

    fs.writeFileSync(storageState, "{}"); // create empty JSON file
  }

  /* register a generic test user */
  console.log(
    textColorize("Setup (global): Registering a generic test user...")
  );

  // create page
  const browser = await chromium.launch();
  const page = await browser.newPage({ storageState: undefined });

  // create page object model
  const accountsRegisterPage = new AccountsRegisterPage(page);
  await accountsRegisterPage.goto();

  // register the user
  await accountsRegisterPage.register(testUserEmail, passwordValid);

  // // TODO: show different message in console based on whether or not
  // // registration was successful

  // /* NOTE: this line hasn't been tested. I just cribbed it from fixtures. */
  // await page.waitForURL(accountsRegisterPage.urlSuccess);

  console.log(
    textColorize(
      "Setup (global): Generic test user registration complete.",
      ConsoleColors.Info
    )
  );
}

export default globalSetup;
