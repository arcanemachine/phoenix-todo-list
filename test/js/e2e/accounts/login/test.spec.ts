import { test, expect } from "@playwright/test";

import { testUserEmail, validPassword } from "test/support/constants";
import { AccountsLoginPage } from "./page";

test.describe("Account login page", () => {
  let accountsLoginPage: AccountsLoginPage;

  test.beforeEach(async ({ page }) => {
    accountsLoginPage = new AccountsLoginPage(page);
    await accountsLoginPage.goto();
  });

  test("logs in a user", async ({ page }) => {
    // log the user in
    await accountsLoginPage.login(testUserEmail, validPassword);

    // page contains expected success message
    await expect(page.getByText("Logged in successfully")).toBeVisible();

    // redirects to expected page
    await expect(page).toHaveURL(accountsLoginPage.urlSuccess);
  });

  // test("shows error if email is invalid", async ({ baseURL, page }) => {});
  // test("shows error if auth credentials are invalid", async ({ baseURL, page }) => {});
});
