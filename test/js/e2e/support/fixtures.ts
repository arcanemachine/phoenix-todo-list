import { test } from "@playwright/test";
import fs from "fs";
import path from "path";
import { validPassword } from "test/support/constants";
import { AccountsRegisterPage } from "e2e/accounts/register/page";
import { emailGenerateRandom } from "e2e/support/helpers";

export * from "@playwright/test";
export const authenticatedTest = test.extend<
  {},
  { workerStorageState: string }
>({
  /** Use the same storage state for all tests in this worker. */
  storageState: ({ workerStorageState }, use) => use(workerStorageState),

  // authenticate once per worker with a worker-scoped fixture.
  workerStorageState: [
    async ({ browser }, use) => {
      // use parallelIndex as a unique identifier for each worker.
      const id = test.info().parallelIndex;
      const fileName = path.resolve(
        test.info().project.outputDir,
        `e2e/.auth/${id}.json`
      );

      if (fs.existsSync(fileName)) {
        // if authentication state already exists for this worker, then reuse it
        await use(fileName);
        return;
      }

      // using a new session, register an account for this worker. the user will
      // be automatically logged in after registration
      const page = await browser.newPage({
        storageState: undefined,
        ignoreHTTPSErrors: true,
      });
      const accountsRegisterPage = new AccountsRegisterPage(page);
      await accountsRegisterPage.goto();
      await accountsRegisterPage.register(emailGenerateRandom(), validPassword);
      await page.waitForURL(accountsRegisterPage.urlSuccess);

      await page.context().storageState({ path: fileName });
      await page.close();
      await use(fileName);
    },
    { scope: "worker" },
  ],
});
