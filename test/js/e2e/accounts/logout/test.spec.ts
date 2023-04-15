import unauthenticatedTest from "@playwright/test";
import { expect } from "@playwright/test";

import { authenticatedTest } from "test/e2e/support/fixtures";
import { AccountsLogoutPage } from "./page";

unauthenticatedTest.describe("[Unauthenticated] Account logout page", () => {
  let testPage: AccountsLogoutPage;

  unauthenticatedTest.beforeEach(async ({ page }) => {
    // navigate to test page
    testPage = new AccountsLogoutPage(page);
    await testPage.goto();
  });

  unauthenticatedTest("shows expected form buttons", async () => {
    await expect(testPage.formButtonHome).toBeVisible();
    await expect(testPage.formButtonLogin).toBeVisible();
  });
});

authenticatedTest.describe("[Authenticated] Account logout page", () => {
  let testPage: AccountsLogoutPage;

  authenticatedTest.beforeEach(async ({ page }) => {
    // navigate to test page
    testPage = new AccountsLogoutPage(page);
    await testPage.goto();
  });

  authenticatedTest("shows expected form buttons", async () => {
    await expect(testPage.formButtonCancel).toBeVisible();
    await expect(testPage.formButtonSubmit).toBeVisible();
  });

  authenticatedTest("logs out an authenticated user", async ({ page }) => {
    // perform action
    await testPage.logout();

    // page redirected to expected URL
    await expect(page).toHaveURL(testPage.urlSuccess.toString());

    // page contains expected success message
    await expect(page.getByText("Logged out successfully")).toBeVisible();
  });
});
