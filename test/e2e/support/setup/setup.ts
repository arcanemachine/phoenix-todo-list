import * as fs from "fs";
import { test } from "@playwright/test";

import { phoenix, urls } from "test/constants";
import config from "test/playwright.config";
import { userLogin } from "e2e/support/helpers";

const baseURL = config.use!.baseURL;
const testUserEmail = "e2e_test_user@example.com";
const storageState = config.use!.storageState as string;

import { validPassword } from "../../../constants";

console.log(`host: ${process.env.PHX_HOST}`);

// // create storageState.json if it doesn't already exist
// if (!fs.existsSync(storageState)) {
//   console.log(`File '${storageState}' doesn't exist. Creating it now...`);
//
//   fs.writeFileSync(storageState, "{}"); // create empty JSON file
// }
//
// test("login user", async ({ page }) => {
//   const now = new Date().getTime();
//   const oneDay = 1000 * 60 * 60 * 24;
//
//   // skip authentication if session token will be valid for more than a day
//   const stats = fs.existsSync(storageState!.toString())
//     ? fs.statSync(storageState!.toString())
//     : null;
//   if (stats && stats.mtimeMs > now - phoenix.sessionValidityDuration - oneDay) {
//     console.log(
//       `\x1b[2m\tSession token is still valid. Skipping authentication...\x1b[0m`
//     );
//     return;
//   } else {
//     // if the token is about to expire, then clear the contents of
//     // sessionStorage.json and create a new auth session.
//   }
//
//   console.log(`\x1b[2m\tSigning in as '${testUserEmail}'...\x1b[0m`);
//
//   await page.goto(baseURL + urls.users.login);
//   userLogin(page, testUserEmail, validPassword);
//
//   console.log(`\x1b[2m\tSign in complete\x1b[0m`);
//
//   await page.context().storageState({ path: storageState });
// });
