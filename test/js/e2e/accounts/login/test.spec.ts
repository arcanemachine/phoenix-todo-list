import { test, expect } from "@playwright/test";

import {
  passwordInvalid,
  passwordValid,
  testUserEmail,
} from "test/support/constants";
import { AccountsLoginPage } from "./page";

test.describe("Account login page", () => {
  let accountsLoginPage: AccountsLoginPage;

  test.beforeEach(async ({ page }) => {
    // navigate to test page
    accountsLoginPage = new AccountsLoginPage(page);
    await accountsLoginPage.goto();
  });

  test("logs in a user", async ({ page }) => {
    // perform action
    await accountsLoginPage.login(testUserEmail, passwordValid);

    // page redirects to expected URL
    await expect(page).toHaveURL(accountsLoginPage.urlSuccess.toString());

    // page contains expected success message
    await expect(page.getByText("Logged in successfully")).toBeVisible();
  });

  test("shows error if auth credentials are invalid", async ({ page }) => {
    // perform action
    await accountsLoginPage.login(testUserEmail, passwordInvalid);

    // page contains expected error message
    await expect(page.getByText("Invalid email or password")).toBeVisible();
  });
});
