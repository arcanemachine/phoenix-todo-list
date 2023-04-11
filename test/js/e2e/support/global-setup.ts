import { chromium, FullConfig } from "@playwright/test";

import { testUserEmail, validPassword } from "test/support/constants";
import { AccountsRegisterPage } from "e2e/accounts/register/page";
import { ConsoleColors, textColorize } from "test/support/helpers";

async function globalSetup(config: FullConfig) {
  config; // this line is only here so the linter will be quiet

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
  await accountsRegisterPage.register(testUserEmail, validPassword);

  // TODO: show different message in console based on whether or not
  // registration was successful

  console.log(
    textColorize(
      "Setup (global): Generic test user registration complete.",
      ConsoleColors.Info
    )
  );
}

export default globalSetup;
