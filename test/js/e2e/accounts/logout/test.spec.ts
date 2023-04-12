import test from "@playwright/test";

import { expect, authenticatedTest } from "e2e/support/fixtures";
import { AccountsLogoutPage } from "./page";

// disable parallel tests so that the authenticated test will show the expected
// form buttons without being logged out by the previous tests
test.describe.configure({ mode: "serial" });

test.describe("[Unauthenticated] Account logout page", () => {
  let accountsLogoutPage: AccountsLogoutPage;

  test.beforeEach(async ({ page }) => {
    // navigate to test page
    accountsLogoutPage = new AccountsLogoutPage(page);
    await accountsLogoutPage.goto();
  });

  test("shows expected form buttons", async () => {
    await expect(accountsLogoutPage.formButtonHome).toBeVisible();
    await expect(accountsLogoutPage.formButtonLogin).toBeVisible();
  });
});

authenticatedTest.describe("[Authenticated] Account logout page", () => {
  let accountsLogoutPage: AccountsLogoutPage;

  authenticatedTest.beforeEach(async ({ page }) => {
    accountsLogoutPage = new AccountsLogoutPage(page);
    await accountsLogoutPage.goto();
  });

  authenticatedTest("shows expected form buttons", async () => {
    await expect(accountsLogoutPage.formButtonCancel).toBeVisible();
    await expect(accountsLogoutPage.formButtonSubmit).toBeVisible();
  });

  authenticatedTest("logs out an authenticated user", async ({ page }) => {
    // perform action
    await accountsLogoutPage.logout();

    // page contains expected success message
    await expect(page.getByText("Logged out successfully")).toBeVisible();

    // redirects to expected page
    await expect(page).toHaveURL(accountsLogoutPage.urlSuccess);
  });
});
