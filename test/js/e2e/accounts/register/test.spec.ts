import { test, expect } from "@playwright/test";

import {
  emailInvalid,
  errors,
  passwordValid,
  testUserEmail,
} from "test/support/constants";
import { emailGenerateRandom } from "e2e/support/helpers";
import { AccountsRegisterPage } from "./page";

test.describe("Account register page", () => {
  let accountsRegisterPage: AccountsRegisterPage;
  let randomEmail: string;

  test.beforeAll(async () => {});

  test.beforeEach(async ({ page }) => {
    randomEmail = emailGenerateRandom(); // generate a random email for each test

    // navigate to test page
    accountsRegisterPage = new AccountsRegisterPage(page);
    await accountsRegisterPage.goto();
  });

  test("registers a new user", async ({ page }) => {
    // perform action
    await accountsRegisterPage.register(randomEmail, passwordValid);

    // redirects to expected page
    await expect(page).toHaveURL(accountsRegisterPage.urlSuccess);

    // page contains expected success message
    await expect(page.getByText("Account created successfully")).toBeVisible();
  });

  test("shows expected error if email is invalid", async () => {
    // perform action
    await accountsRegisterPage.register(emailInvalid, passwordValid, {
      submit: false,
    });

    // form contains expected error
    await expect(accountsRegisterPage.inputErrorEmail).toBeVisible();
    await expect(accountsRegisterPage.inputErrorEmail).toHaveText(
      errors.email.isInvalid
    );
  });

  test("shows expected error if email is taken", async () => {
    const takenEmail = testUserEmail;

    // perform action
    await accountsRegisterPage.register(takenEmail, passwordValid);

    // form contains expected error
    await expect(accountsRegisterPage.inputErrorEmail).toBeVisible();
    await expect(accountsRegisterPage.inputErrorEmail).toHaveText(
      errors.email.isTaken
    );
  });

  test("shows expected error if passwords do not match", async () => {
    const nonMatchingPassword = passwordValid + "a";

    // perform action
    await accountsRegisterPage.register(randomEmail, passwordValid, {
      passwordConfirmation: nonMatchingPassword,
      submit: false,
    });

    // form contains expected error
    await expect(
      accountsRegisterPage.inputErrorPasswordConfirmation
    ).toBeVisible();
    await expect(
      accountsRegisterPage.inputErrorPasswordConfirmation
    ).toHaveText(errors.passwordConfirmation.doesNotMatch);
  });
});
