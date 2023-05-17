import { test, expect } from "@playwright/test";

import {
  passwordInvalid,
  passwordValid,
  testUserEmail,
} from "tests/support/constants";
import { AccountsLoginPage } from "./page";

test.describe("Account login page", () => {
  let testPage: AccountsLoginPage;

  test.beforeEach(async ({ page }) => {
    // navigate to test page
    testPage = new AccountsLoginPage(page);
    await testPage.goto();

    // ensure that the live socket connection has been established
    await expect(testPage.phxConnected).toBeVisible();
  });

  test("logs in a user", async ({ page }) => {
    // perform action
    await testPage.login(testUserEmail, passwordValid);

    // page redirects to expected URL
    await expect(page).toHaveURL(testPage.urlSuccess.toString());

    // page contains expected success message
    await expect(page.getByText("Logged in successfully")).toBeVisible();
  });

  test("shows error if auth credentials are invalid", async ({ page }) => {
    // perform action
    await testPage.login(testUserEmail, passwordInvalid);

    // page contains expected error message
    await expect(page.getByText("Invalid email or password")).toBeVisible();
  });
});
