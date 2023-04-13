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

    // page contains expected success message
    await expect(page.getByText("Logged in successfully")).toBeVisible();

    // redirects to expected page
    await expect(page).toHaveURL(accountsLoginPage.urlSuccess.toString());
  });

  test("shows error if auth credentials are invalid", async ({ page }) => {
    // perform action
    await accountsLoginPage.login(testUserEmail, passwordInvalid);

    // page contains expected error message
    await expect(page.getByText("Invalid email or password")).toBeVisible();
  });
});
