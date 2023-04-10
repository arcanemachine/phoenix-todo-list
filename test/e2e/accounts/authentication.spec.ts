// import { chromium, test, expect, Cookie } from "@playwright/test";
import { chromium, test, expect } from "@playwright/test";

import {
  generateRandomEmail,
  userLogin,
  userRegister,
} from "e2e/support/helpers";
import { urls, validPassword } from "test/constants";
import config from "test/playwright.config";

const baseURL = config.use!.baseURL;
const randomEmail = generateRandomEmail(); // generate a new user on every run
// let cookies: Array<Cookie>;

test.describe(urls.users.register, () => {
  // let cookies: any;

  // test.beforeEach(async ({ page, context }) => {
  test.beforeEach(async ({ page }) => {
    //   // temporarily clear session data
    //   cookies = await context.cookies();
    //   await context.clearCookies();

    await page.goto(baseURL + urls.users.register); // navigate to test URL
  });

  // test.afterEach(async ({ context }) => {
  //   await context.addCookies(cookies); // restore session data
  // });

  test("registers a new user", async ({ baseURL, page }) => {
    // register new user
    await userRegister(page, randomEmail, validPassword);

    // redirects to expected page
    await expect(page).toHaveURL(baseURL + "/todos/live");
  });

  // test("shows error if email is invalid", async ({ baseURL, page }) => {});
  // test("shows error if email is taken", async ({ baseURL, page }) => {});
  // test("shows error if password is too short", async ({ baseURL, page }) => {});
  // test("shows error if passwords do not match", async ({ baseURL, page }) => {});
});

test.describe(urls.users.login, () => {
  // test.beforeAll(async ({ browserName }) => {
  test.beforeAll(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    /* register the user used in this test suite */
    await page.goto(baseURL + urls.users.register); // navigate to test URL
    await userRegister(page, randomEmail, validPassword);
  });

  // test.beforeEach(async ({ page, context }) => {
  test.beforeEach(async ({ page }) => {
    //   // temporarily clear session data
    //   cookies = await context.cookies();
    //   await context.clearCookies();

    await page.goto(baseURL + urls.users.login); // navigate to test URL
  });

  // test.afterEach(async ({ context }) => {
  //   await context.addCookies(cookies); // restore session data
  // });

  test("logs a user in", async ({ baseURL, page }) => {
    await userLogin(page, randomEmail, validPassword);

    // redirects to expected page
    await expect(page).toHaveURL(baseURL + "/todos/live");
  });

  // test("shows error if email is invalid", async ({ baseURL, page }) => {});
  // test("shows error if auth credentials are invalid", async ({ baseURL, page }) => {});
});

// test.describe(urls.users.logout, () => {
//   test.beforeEach(async ({ baseURL, page }) => {
//     // navigate to test URL
//     await page.goto(baseURL + urls.users.logout);
//   });
//
//   test("logs a user out", async ({ baseURL, page }) => {
//     // user initially has session cookie
//     await expect(page).toHaveURL(baseURL + "/todos/live");
//
//     // click the 'confirm' button
//     await page.locator("#logout-form-button-submit").click();
//
//     // redirects to expected page
//     await expect(page).toHaveURL(baseURL + "/todos/live");
//
//     // user no longer has session cookie
//     await expect(page).toHaveURL(baseURL + "/todos/live");
//   });
//
//   // test("shows error if email is invalid", async ({ baseURL, page }) => {});
//   // test("shows error if auth credentials are invalid", async ({ baseURL, page }) => {});
// });
