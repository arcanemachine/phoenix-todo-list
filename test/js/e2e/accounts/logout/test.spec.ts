import test from "@playwright/test";
import { expect, test as authenticatedTest } from "e2e/fixtures";

import { AccountsLogoutPage } from "./page";

test.describe("[Unauthenticated] Account logout page", () => {
  let accountsLogoutPage: AccountsLogoutPage;

  test.beforeEach(async ({ page }) => {
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
    // log the user out
    await accountsLogoutPage.logout();

    // page contains expected success message
    await expect(page.getByText("Logged out successfully")).toBeVisible();

    // redirects to expected page
    await expect(page).toHaveURL(accountsLogoutPage.urlSuccess);
  });
});
