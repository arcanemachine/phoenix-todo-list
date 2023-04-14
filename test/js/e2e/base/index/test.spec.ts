import { test, expect } from "@playwright/test";

import { BaseIndexPage } from "./page";

test.describe("Base index page", () => {
  let baseIndexPage: BaseIndexPage;

  test.beforeEach(async ({ page }) => {
    // navigate to test page
    baseIndexPage = new BaseIndexPage(page);
    await baseIndexPage.goto();
  });

  test("contains expected title", async () => {
    await expect(baseIndexPage.title).toHaveText("Home");
  });
});
