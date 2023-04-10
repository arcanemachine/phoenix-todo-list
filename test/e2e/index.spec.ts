import { test, expect } from "@playwright/test";

test.describe.only("Page", () => {
  test("contains expected title", async ({ baseURL, page }) => {
    await page.goto(baseURL as string);
    await expect(page).toHaveTitle(/Home/);
  });
});
