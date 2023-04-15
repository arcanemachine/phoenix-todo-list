import { test, expect } from "@playwright/test";

import { BaseIndexPage } from "./page";

test.describe("Base index page", () => {
  let testPage: BaseIndexPage;

  test.beforeEach(async ({ page }) => {
    // navigate to test page
    testPage = new BaseIndexPage(page);
    await testPage.goto();
  });

  test("contains expected title", async () => {
    await expect(testPage.title).toHaveText("Home");
  });
});
