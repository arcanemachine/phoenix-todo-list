/**
 * These tests use the generic Playwright `test()` method to avoid issues
 * caused by logging out of the session used by authenticated workers.
 */
import test from "@playwright/test";
import { expect } from "@playwright/test";
import { AccountsLoginPage } from "test/e2e/accounts/login/page";
import { passwordValid, testUserEmail } from "test/support/constants";

import { AccountsLogoutPage } from "./page";

test.describe("[Unauthenticated] Account logout page", () => {
  let testPage: AccountsLogoutPage;

  test.beforeEach(async ({ page }) => {
    // navigate to test page
    testPage = new AccountsLogoutPage(page);
    await testPage.goto();
  });

  test("shows expected form buttons", async () => {
    await expect(testPage.formButtonHome).toBeVisible();
    await expect(testPage.formButtonLogin).toBeVisible();
  });
});

test.describe("[Authenticated] Account logout page", () => {
  let testPage: AccountsLogoutPage;
  let accountsLoginPage: AccountsLoginPage;

  test.beforeEach(async ({ page }) => {
    // login as generic test user
    accountsLoginPage = new AccountsLoginPage(page);
    await accountsLoginPage.goto();
    await accountsLoginPage.login(testUserEmail, passwordValid);

    // navigate to test page
    testPage = new AccountsLogoutPage(page);
    await testPage.goto();
  });

  test("shows expected form buttons", async () => {
    await expect(testPage.formButtonCancel).toBeVisible();
    await expect(testPage.formButtonSubmit).toBeVisible();
  });

  test("logs out an authenticated user", async ({ page }) => {
    // perform action
    await testPage.logout();

    // page redirected to expected URL
    await expect(page).toHaveURL(testPage.urlSuccess.toString());

    // page contains expected success message
    await expect(page.getByText("Logged out successfully")).toBeVisible();
  });
});
