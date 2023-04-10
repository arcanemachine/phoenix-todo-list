import * as fs from "fs";
import { test } from "@playwright/test";

import { phoenix, urls } from "test/constants";
import config from "test/playwright.config";
import { userLogin } from "e2e/support/helpers";

// import * as dotenv from 'dotenv';

const baseURL = config.use!.baseURL;
const testUserEmail = "e2e_test_user@example.com";
const storageState = config.use!.storageState as string;

import { validPassword } from "../../../constants";

// // we don't want to store credentials in the repository
// dotenv.config({
//     path: './e2e/.env.local',
// });

// create storageState.json if it doesn't already exist
if (!fs.existsSync(storageState)) {
  console.log(`File '${storageState}' doesn't exist. Creating it now...`);

  fs.writeFileSync(storageState, "{}"); // create empty JSON file
}

test("login user", async ({ page }) => {
  // if (process.env.username === "**REMOVED**") {
  //   throw new Error("Env file is not correct");
  // }

  // skip authentication if session token will be valid for an
  const stats = fs.existsSync(storageState!.toString())
    ? fs.statSync(storageState!.toString())
    : null;
  if (
    stats &&
    stats.mtimeMs > new Date().getTime() - phoenix.sessionValidityDuration
  ) {
    console.log(
      `\x1b[2m\tSession token is still valid. Skipping authentication..\x1b[0m`
    );
    return;
  } else {
    // if the token is about to expire, then clear the contents of
    // sessionStorage.json and create a new auth session.
  }

  console.log(`\x1b[2m\tSigning in as '${testUserEmail}'...\x1b[0m`);

  await page.goto(baseURL + urls.users.login);
  userLogin(page, testUserEmail, validPassword);

  console.log(`\x1b[2m\tSign in complete\x1b[0m`);

  await page.context().storageState({ path: storageState });
});
