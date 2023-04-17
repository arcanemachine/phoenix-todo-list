import fs from "fs";
import { FullConfig, chromium } from "@playwright/test";

import { AccountsRegisterPage } from "test/e2e/accounts/register/page";
import { storageState } from "test/e2e/support/constants";
import { testUserEmail, passwordValid } from "test/support/constants";
import { textColorize } from "test/support/helpers";

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

  // FIXME: this logic needs to be moved into the context of a fixture (I think...)
  // /* setup SQL sandbox */
  // console.log(textColorize("Setup (global): Setting up SQL sandbox..."));
  //
  // // get custom user agent from sandbox setup endpoint
  // state.sqlSandboxUserAgent = await fetch(`${state.baseUrl}/sandbox`, {
  //   method: "POST",
  // })
  //   .then(
  //     (res) => res.text() // SQL sandbox setup successful. use custom user agent
  //   )
  //   .catch(() => {
  //     // SQL sandbox setup unsuccessful. use default user agent
  //     console.log(
  //       textColorize(
  //         "Setup (global): Could not set up SQL sandbox. " +
  //           "The test database will need to be cleared manually.",
  //         "warning"
  //       )
  //     );
  //     return undefined;
  //   });
  //
  // const context = state.sqlSandboxUserAgent
  //   ? await browser.newContext({ userAgent: state.sqlSandboxUserAgent })
  //   : await browser.newContext();
  //
  // // create page object
  // const page = await context.newPage();

  // register generic test user
  console.log(textColorize("Setup (global): Registering generic test user..."));
  const accountsRegisterPage = new AccountsRegisterPage(page);
  await accountsRegisterPage.goto();
  await accountsRegisterPage.register(testUserEmail, passwordValid);
}

export default globalSetup;
