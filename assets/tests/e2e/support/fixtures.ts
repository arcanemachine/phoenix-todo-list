import fs from "fs";
import path from "path";
import { Page, expect, test } from "@playwright/test";

import { AccountsRegisterPage } from "tests/e2e/accounts/register/page";
import { emailGenerateRandom } from "tests/e2e/support/helpers";
import { passwordValid, urls } from "tests/support/constants";

const baseTest = test.extend({}); // shared logic common to all tests

export * from "@playwright/test";
export const authenticatedTest = baseTest.extend<
  {},
  { workerStorageState: string }
>({
  /** Use the same storage state for all tests in this worker. */
  storageState: ({ workerStorageState }, use) => use(workerStorageState),

  // authenticate once per worker with a worker-scoped fixture.
  workerStorageState: [
    async ({ browser }, use) => {
      // use parallelIndex as a unique identifier for each worker.
      const workerId = test.info().parallelIndex;
      const fileName = path.resolve(
        test.info().project.outputDir,
        `e2e/.auth/${workerId}.json`
      );

      // reuse valid authentication states when possible
      if (fs.existsSync(fileName)) {
        // if authentication state already exists for this worker, then reuse it
        await use(fileName);
        return;
      }

      // using a new session, create and log into an account for this worker
      // (the user will be automatically logged in after registration)
      const page = await browser.newPage({
        storageState: undefined,
        ignoreHTTPSErrors: true,
      });
      const accountsRegisterPage = new AccountsRegisterPage(page);
      await accountsRegisterPage.goto();
      await accountsRegisterPage.register(emailGenerateRandom(), passwordValid);

      // wait for success URL to load so that we know the cookies have been saved
      await page.waitForURL(accountsRegisterPage.urlSuccess.toString());

      await page.context().storageState({ path: fileName });
      await page.close();
      await use(fileName);
    },
    { scope: "worker" },
  ],
});

export const unauthenticatedTest = baseTest;

// generic/reusable tests
function redirectsUnauthenticatedUserToLoginPage(
  pageName: string,
  PageClass: any
) {
  return baseTest.describe(`[Unauthenticated] ${pageName}`, () => {
    let testPage: Page;

    test.beforeEach(async ({ page }) => {
      // navigate to test page
      testPage = new PageClass(page);
      await testPage.goto(testPage.url.toString());
    });

    test("redirects to login page", async ({ page }) => {
      // page redirected to expected URL
      await expect(page).toHaveURL(urls.accounts.login.toString());

      // redirects to expected URL
      await expect(page).toHaveURL(urls.accounts.login.toString());
    });
  });
}

export const genericTests = {
  redirectsUnauthenticatedUserToLoginPage,
};
