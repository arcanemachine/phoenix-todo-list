import unauthenticatedTest from "@playwright/test";
import { expect } from "@playwright/test";

import { authenticatedTest } from "e2e/support/fixtures";
import { AccountsLogoutPage } from "./page";

unauthenticatedTest.describe("[Unauthenticated] Account logout page", () => {
  let accountsLogoutPage: AccountsLogoutPage;

  unauthenticatedTest.beforeEach(async ({ page }) => {
    // navigate to test page
    accountsLogoutPage = new AccountsLogoutPage(page);
    await accountsLogoutPage.goto();
  });

  unauthenticatedTest("shows expected form buttons", async () => {
    await expect(accountsLogoutPage.formButtonHome).toBeVisible();
    await expect(accountsLogoutPage.formButtonLogin).toBeVisible();
  });
});

authenticatedTest.describe("[Authenticated] Account logout page", () => {
  let accountsLogoutPage: AccountsLogoutPage;

  authenticatedTest.beforeEach(async ({ page }) => {
    // navigate to test page
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

    // page redirected to expected URL
    await expect(page).toHaveURL(accountsLogoutPage.urlSuccess.toString());

    // page contains expected success message
    await expect(page.getByText("Logged out successfully")).toBeVisible();
  });
});
