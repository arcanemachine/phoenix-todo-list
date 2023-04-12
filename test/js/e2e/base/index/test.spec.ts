import { test, expect } from "@playwright/test";

import { BaseIndexPage } from "./page";

test.describe("Base index page", () => {
  test("should contain expected title", async ({ page }) => {
    const baseIndex = new BaseIndexPage(page);
    await baseIndex.goto();
    await expect(baseIndex.title).toHaveText("Home");
  });
});
