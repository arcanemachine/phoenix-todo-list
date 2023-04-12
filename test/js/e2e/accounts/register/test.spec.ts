import { test, expect } from "@playwright/test";

import { passwordValid } from "test/support/constants";
import { emailGenerateRandom } from "e2e/support/helpers";
import { AccountsRegisterPage } from "./page";

test.describe("Account register page", () => {
  let accountsRegisterPage: AccountsRegisterPage;
  let testUserEmail: string;

  test.beforeAll(async () => {
    testUserEmail = emailGenerateRandom(); // generate a new user on every run
  });

  test.beforeEach(async ({ page }) => {
    accountsRegisterPage = new AccountsRegisterPage(page);
    await accountsRegisterPage.goto();
  });

  test("registers a new user", async ({ page }) => {
    // register new user
    await accountsRegisterPage.register(testUserEmail, passwordValid);

    // redirects to expected page
    expect(page).toHaveURL(accountsRegisterPage.urlSuccess);

    // page contains expected success message
    await expect(page.getByText("Account created successfully")).toBeVisible();
  });

  // test("shows error if email is invalid", async ({ baseURL, page }) => {});
  // test("shows error if email is taken", async ({ baseURL, page }) => {});
  // test("shows error if password is too short", async ({ baseURL, page }) => {});
  // test("shows error if passwords do not match", async ({ baseURL, page }) => {});
});
