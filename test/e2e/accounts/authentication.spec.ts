import { chromium, test, expect } from "@playwright/test";

import {
  generateRandomEmail,
  userLogin,
  userLogout,
  userRegister,
} from "e2e/support/helpers";
import { urls, validPassword } from "test/constants";
import config from "test/playwright.config";

const baseURL = config.use!.baseURL;
const testUserEmail = generateRandomEmail(); // generate a new user on every run

test.describe(urls.users.register, () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(baseURL + urls.users.register); // navigate to test URL
  });

  test("registers a new user", async ({ page }) => {
    await userRegister(page, testUserEmail, validPassword);

    // redirects to expected page
    expect(page).toHaveURL(baseURL + "/todos/live");

    // page contains expected success message
    await expect(page.getByText("Account created successfully")).toBeVisible();
  });

  // test("shows error if email is invalid", async ({ baseURL, page }) => {});
  // test("shows error if email is taken", async ({ baseURL, page }) => {});
  // test("shows error if password is too short", async ({ baseURL, page }) => {});
  // test("shows error if passwords do not match", async ({ baseURL, page }) => {});
});

test.describe(urls.users.login, () => {
  test.beforeAll(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    // ensure that a user is registered for this test suite
    await userRegister(page, testUserEmail, validPassword, {
      navigateToUrl: true,
      login: false,
    });
  });

  test.beforeEach(async ({ page }) => {
    // ensure that the user is logged out
    await page.goto(baseURL + urls.users.logout); // navigate to test URL
  });

  test("logs in a user", async ({ baseURL, page }) => {
    await userLogin(page, testUserEmail, validPassword);

    // page contains expected success message
    await expect(page.getByText("Logged in successfully")).toBeVisible();

    // redirects to expected page
    await expect(page).toHaveURL(baseURL + "/todos/live");
  });

  // test("shows error if email is invalid", async ({ baseURL, page }) => {});
  // test("shows error if auth credentials are invalid", async ({ baseURL, page }) => {});
});

test.describe(urls.users.logout, () => {
  test.beforeAll(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    // ensure that a user is registered in for this test suite
    await userRegister(page, testUserEmail, validPassword, {
      navigateToUrl: true,
    });
  });

  test.beforeEach(async ({ baseURL, page }) => {
    // ensure that user is logged in
    await userLogin(page, testUserEmail, validPassword, {
      navigateToUrl: true,
    });

    // navigate to test URL
    await page.goto(baseURL + urls.users.logout);
  });

  test("logs out an authenticated user", async ({ page }) => {
    // log the user out
    await userLogout(page, { navigateToUrl: false });

    // page contains expected success message
    await expect(page.getByText("Logged out successfully")).toBeVisible();

    // redirects to expected page
    await expect(page).toHaveURL(baseURL + "/");
  });

  // test("shows error if email is invalid", async ({ baseURL, page }) => {});
  // test("shows error if auth credentials are invalid", async ({ baseURL, page }) => {});
});
