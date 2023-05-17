/**
 * All tests in this module use the `unauthenticatedTest` method. This prevents
 * loss of session data caused by logging out any users used in authenticated
 * test fixtures.
 */
import { expect } from "@playwright/test";
import { AccountsLoginPage } from "tests/e2e/accounts/login/page";
import { passwordValid, testUserEmail } from "tests/support/constants";

import { unauthenticatedTest } from "tests/e2e/support/fixtures";
import { AccountsLogoutPage } from "./page";

unauthenticatedTest.describe("[Unauthenticated] Account logout page", () => {
  let testPage: AccountsLogoutPage;

  unauthenticatedTest.beforeEach(async ({ page }) => {
    // navigate to test page
    testPage = new AccountsLogoutPage(page);
    await testPage.goto();

    // ensure that the live socket connection has been established
    await expect(testPage.phxConnected).toBeVisible();
  });

  unauthenticatedTest("shows expected form buttons", async () => {
    await expect(testPage.formButtonHome).toBeVisible();
    await expect(testPage.formButtonLogin).toBeVisible();
  });
});

unauthenticatedTest.describe("[Authenticated] Account logout page", () => {
  let testPage: AccountsLogoutPage;
  let accountsLoginPage: AccountsLoginPage;

  unauthenticatedTest.beforeEach(async ({ page }) => {
    // login as generic test user
    accountsLoginPage = new AccountsLoginPage(page);
    await accountsLoginPage.goto();
    await accountsLoginPage.login(testUserEmail, passwordValid);

    // navigate to test page
    testPage = new AccountsLogoutPage(page);
    await testPage.goto();
  });

  unauthenticatedTest("shows expected form buttons", async () => {
    await expect(testPage.formButtonCancel).toBeVisible();
    await expect(testPage.formButtonSubmit).toBeVisible();
  });

  unauthenticatedTest("logs out an authenticated user", async ({ page }) => {
    // perform action
    await testPage.logout();

    // page redirected to expected URL
    await expect(page).toHaveURL(testPage.urlSuccess.toString());

    // page contains expected success message
    await expect(page.getByText("Logged out successfully")).toBeVisible();
  });
});
