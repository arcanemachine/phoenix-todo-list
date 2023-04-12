import { test, expect } from "@playwright/test";

import { BaseIndexPage } from "./page";

test.describe("Base index page", () => {
  test("should contain expected title", async ({ page }) => {
    // navigate to test page
    const baseIndex = new BaseIndexPage(page);
    await baseIndex.goto();

    // page contains expected title
    await expect(baseIndex.title).toHaveText("Home");
  });
});
