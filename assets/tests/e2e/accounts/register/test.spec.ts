import { test, expect } from "@playwright/test";

import { emailGenerateRandom } from "tests/e2e/support/helpers";
import {
  emailInvalid,
  errors,
  passwordValid,
  testUserEmail,
} from "tests/support/constants";
import { AccountsRegisterPage } from "./page";

test.describe("Account register page", () => {
  let testPage: AccountsRegisterPage;
  let randomEmail: string;

  test.beforeEach(async ({ page }) => {
    randomEmail = emailGenerateRandom(); // generate a random email for each test

    // navigate to test page
    testPage = new AccountsRegisterPage(page);
    await testPage.goto();

    // ensure that the live socket connection has been established
    await expect(testPage.phxConnected).toBeVisible();
  });

  test("registers a new user", async ({ page }) => {
    // perform action
    await testPage.register(randomEmail, passwordValid);

    // page redirects to expected URL
    await expect(page).toHaveURL(testPage.urlSuccess.toString());

    // page contains expected success message
    await expect(page.getByText("Account created successfully")).toBeVisible();
  });

  test("shows expected error if email is invalid", async () => {
    // perform action
    await testPage.register(emailInvalid, passwordValid, {
      submit: false,
    });

    // form contains expected error
    await expect(testPage.inputErrorEmail).toBeVisible();
    await expect(testPage.inputErrorEmail).toHaveText(errors.email.isInvalid);
  });

  test("shows expected error if email is taken", async () => {
    const takenEmail = testUserEmail;

    // perform action
    await testPage.register(takenEmail, passwordValid);

    // form contains expected error
    await expect(testPage.inputErrorEmail).toBeVisible();
    await expect(testPage.inputErrorEmail).toHaveText(errors.email.isTaken);
  });

  test("shows expected error if passwords do not match", async () => {
    const nonMatchingPassword = passwordValid + "a";

    // perform action
    await testPage.register(randomEmail, passwordValid, {
      passwordConfirmation: nonMatchingPassword,
      submit: false,
    });

    // form contains expected error
    await expect(testPage.inputErrorPasswordConfirmation).toBeVisible();
    await expect(testPage.inputErrorPasswordConfirmation).toHaveText(
      errors.passwordConfirmation.doesNotMatch
    );
  });
});
